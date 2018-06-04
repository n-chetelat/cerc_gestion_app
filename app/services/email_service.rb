class EmailService

  attr_reader :google_service, :gmail_service

  def initialize(request)
    @google_service = ::GoogleService.new(request)
    @gmail_service = @google_service.gmail_service
  end

  USER_ID = ENV['GMAIL_ADDRESS']

  def send_email_to(mail_object, options={})

    message = Google::Apis::GmailV1::Message.new(
      raw: mail_object.to_s
    )

    if options[:thread_id]
      # Check if thread exists. There can be an error if it was deleted from inbox.
      thread_exists = self.thread_exists_in_inbox?(options[:thread_id])
      message.thread_id = options[:thread_id] if thread_exists
    end
    gmail_service.send_user_message(USER_ID, message) do |result, error|
      raise error if error
      return if options[:do_not_save_thread]
      thread = ::Email::Thread.find_or_create_by(google_thread_id: result.thread_id)
      self.fetch_thread_message_details(thread)
      self.associate_thread_with_persons!(thread, result.thread_id)
      return thread
    end
  end

  def thread_exists_in_inbox?(google_thread_id)
    thread_exists = gmail_service.get_user_thread(USER_ID, google_thread_id) rescue false
    !!thread_exists
  end

  def create_email_label!(phase, name)
    if label = Email::Label.find_by(name: name)
      raise "Label '#{name}' already associated with phase '#{label.phase.title}'"
    end
    # Check if label already exists (Gmail API does not have 'upsert labels')
    existing_label = nil
    gmail_service.list_user_labels(USER_ID) do |result, error|
      raise error if error
      if label = result.labels.find {|lb| lb.name == name}
        existing_label = label
      end
    end
    phase.email_label ||= phase.build_email_label
    if existing_label.nil?
      label_object = Google::Apis::GmailV1::Label.new(name: name)
      gmail_service.create_user_label(USER_ID, label_object) do |result, error|
        raise error if error
        phase.email_label.name = result.name
        phase.email_label.google_label_id = result.id
      end
    else
      phase.email_label.name = existing_label.name
      phase.email_label.google_label_id = existing_label.id
    end
    phase.email_label.save!
  end

  def update_email_label!(phase, new_name)
    label = phase.email_label
    # Check if label has been erased
    gmail_service.get_user_label(USER_ID, label.google_label_id) do |result, error|
      unless result
        return create_email_label!(phase, new_name)
      end
    end
    label_object = Google::Apis::GmailV1::Label.new(id: label.google_label_id, name: new_name)
    gmail_service.update_user_label(USER_ID, label.google_label_id, label_object) do |result, error|
      raise error if error
      label.update_attributes(name: result.name, google_label_id: result.id)
    end
  end

  def delete_email_label!(phase)
    label = phase.email_label
    label.destroy if label
  end

  def fetch_threads_from_date(date, options={})
    max_results = 100
    query = "after:#{date.strftime("%y/%m/%d")} -in:chats"
    response = nil

    gmail_service.list_user_threads(USER_ID, q: query, max_results: max_results, page_token: options[:next_page_token]) do |result, error|
      raise error if error
      (result.threads || []).each do |thread_object|
        unless thread = Email::Thread.find_by(google_thread_id: thread_object.id)
          thread = Email::Thread.new(google_thread_id: thread_object.id)
        end

        next unless thread.google_history_id != thread_object.history_id.to_s

        associate_thread_with_persons!(thread, thread_object.id)
        thread.google_history_id = thread_object.history_id.to_s
        thread.save! if thread.persons.any? && thread.changed?
        thread.reload

      end
      response = result
    end

    if response.next_page_token
      fetch_threads_from_date(date, {next_page_token: response.next_page_token})
    end
  end

  def associate_thread_with_persons!(thread, gmail_thread_object_id)

    gmail_service.get_user_thread(USER_ID, gmail_thread_object_id) do |result, error|
      raise error if error
      addresses = extract_thread_participants(result).uniq
      persons = Person.where(id: Persons::EmailAddress
        .where(address: addresses).select(:person_id)
      )
      persons.each do |person|
        association = thread.persons_threads.find_or_initialize_by(person_id: person.id)
        if association.save
          # change thread labels
          overwrite_thread_labels(thread, thread.email_labels)
          # preload correspondence with person
          token = SecureRandom.base58(24)
          Email::Token.create!(name: "email-fetch-#{person.uuid}", token: token)
          Email::PersonCorrespondenceWorker.perform_async(person.uuid)
        end
      end
    end
  end

  def fetch_thread_message_details(thread)
    gmail_service.get_user_thread(USER_ID, thread.google_thread_id) do |result, error|
      raise error if error
      extract_thread_message_details(thread, result)
      thread.save!
    end
  end

  def overwrite_thread_labels(thread, add_label_ids)
    gmail_service.get_user_thread(USER_ID, thread.google_thread_id) do |result, error|
      remove_label_ids = result.messages.map {|msg| msg.label_ids }.flatten
        .select {|label| /^Label_\d+$/.match(label) }.uniq - add_label_ids
      update_thread_labels(thread, add_label_ids, remove_label_ids)
    end
  end

  def update_thread_labels(thread, add_label_ids, remove_label_ids)
    return if add_label_ids.empty? && remove_label_ids.empty?
    return if add_label_ids.any? {|label| remove_label_ids.include?(label) }
    request_object = Google::Apis::GmailV1::ModifyThreadRequest.new(
      add_label_ids: add_label_ids.compact, remove_label_ids: remove_label_ids.compact)

    begin
      gmail_service.modify_thread(USER_ID, thread.google_thread_id, request_object)
    rescue ::Google::Apis::ClientError
      false
    end

  end

  private

    def extract_thread_participants(gmail_thread_object)
      value_from = gmail_thread_object.messages.map do |message|
        message.payload.headers.map.find {|header| header.name == "From" }.value
      end.flatten
      value_to = gmail_thread_object.messages.map do |message|
        message.payload.headers.map.find {|header| header.name == "To" }.value
      end.flatten
      mail = Mail.new { to value_to; from value_from }
      mail.from_addrs + mail.to_addrs
    end

    def extract_thread_message_details(thread, gmail_thread_object)
      gmail_thread_object.messages.each do |message|
        next if thread.messages.find_by(google_message_id: message.id)
        formatted_message = format_new_email_message(message)
        thread.messages.create!(google_message_id: message.id,
          content: formatted_message.to_s,
          from_address: formatted_message.from_addrs.first,
          google_timestamp: message.internal_date
        )
      end
    end

    def format_new_email_message(gmail_message_object)
      headers = {}.tap do |h|
        gmail_message_object.payload.headers
        .each {|header| h[header.name] = header.value }
      end
      new_message = Mail.new do
        subject headers["Subject"]
        to headers["To"]
        from headers["From"]
      end

      multipart_part = gmail_message_object.payload.parts.find {|part| part.mime_type == "multipart/alternative" }
      if multipart_part
        parts = multipart_part.parts
      else
        parts = gmail_message_object.payload.parts
      end

      if text_part = parts.find {|part| part.mime_type == "text/plain" }
        new_message.text_part = Mail::Part.new do
          body text_part.body.data.force_encoding("UTF-8")
          body_encoding "utf-8"
        end
      end
      if html_part = parts.find {|part| part.mime_type == "text/html" }
        new_message.html_part = Mail::Part.new do
          content_type "text/html; charset=UTF-8"
          body html_part.body.data.force_encoding("UTF-8")
          body_encoding "utf-8"
        end
      end
      new_message
    end

end
