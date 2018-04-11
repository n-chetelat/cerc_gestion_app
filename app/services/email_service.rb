class EmailService

  attr_reader :google_service, :gmail_service

  def initialize(google_service)
    @google_service = google_service
    @gmail_service = google_service.gmail_service
  end

  USER_ID = ENV['GMAIL_ADDRESS']

  def send_email_to(person, mail_object, options)

    message = Google::Apis::GmailV1::Message.new(
      raw: mail_object.to_s,
      thread_id: options[:thread_id]
    )
    gmail_service.send_user_message(USER_ID, message) do |result, error|
      if error
        raise "There was an error when sending a Gmail message."
      else
        request_object = Google::Apis::GmailV1::ModifyMessageRequest.new(
          add_label_ids: options[:label_ids].compact
        )
        gmail_service.modify_message(USER_ID, result.id, request_object) do |res, err|
          thread = Email::Thread.find_or_initialize_by(google_thread_id: result.thread_id)
          thread.messages.build(
            google_message_id: result.id,
            google_label_ids: result.label_ids,
            content: Base64.encode64(mail_object.to_s)
          )
          thread.persons_threads.build(person_id: person.id)
          thread.save!
        end

      end
    end
  end

  def create_email_label!(phase, name)
    label_object = Google::Apis::GmailV1::Label.new(name: name)
    gmail_service.create_user_label(USER_ID, label_object) do |result, error|
      if error
        nil
      else
        phase.email_label ||= phase.build_email_label
        phase.email_label.name = result.name
        phase.email_label.google_label_id = result.id
        phase.email_label.save!
        phase.email_label.reload
      end
    end
  end

  def update_email_label!(phase, new_name)
    label = phase.email_label
    label_object = Google::Apis::GmailV1::Label.new(id: label.google_label_id, name: new_name)
    gmail_service.update_user_label(USER_ID, label.google_label_id, label_object) do |result, error|
      if error
        nil
      else
        label.update_attributes(name: result.name, google_label_id: result.id)
      end
    end
  end

  def delete_email_label!(phase)
    label = phase.email_label
    return true unless label
    gmail_service.delete_user_label(USER_ID, label.google_label_id) do |result, error|
      if error
        nil
      else
        label.destroy
      end
    end
  end

  def fetch_thread_messages(thread)
    gmail_service.get_user_thread(USER_ID, thread.google_thread_id) do |result, error|
      unless (error)
        result.messages.each do |message|
          if existing_message = thread.messages.find_by(google_message_id: message.id)
            existing_message.google_timestamp = message.internal_date
            existing_message.google_label_ids = message.label_ids
          else
            headers = message.payload.headers
              .select {|header| ["Subject", "To", "From"].include?(header.name) }
              .map(&:value)
            new_message = Mail.new do
              subject headers[0]
              to headers[1]
              from headers[2]
            end
            if text_part = message.payload.parts.find {|part| part.mime_type == "text/plain" }
              new_message.text_part = Mail::Part.new do
                body text_part.body.data
              end
            end
            if html_part = message.payload.parts.find {|part| part.mime_type == "text/html" }
              new_message.html_part = Mail::Part.new do
                content_type "text/html; charset=UTF-8"
                body html_part.body.data
              end
            end

            thread.messages.build(google_message_id: message.id,
              content: Base64.encode64(new_message.to_s),
              google_label_ids: message.label_ids + thread.email_labels,
              google_timestamp: message.internal_date
            )
          end
        end
        thread.save!
      end
    end
  end

  def update_thread_labels(thread, add_label_ids, remove_label_ids)
    return if add_label_ids.empty? && remove_label_ids.empty?
    return if add_label_ids.any? {|label| remove_label_ids.include?(label) }
    request_object = Google::Apis::GmailV1::ModifyThreadRequest.new(
      add_label_ids: add_label_ids.compact, remove_label_ids: remove_label_ids.compact)
    gmail_service.modify_thread(USER_ID, thread.google_thread_id, request_object) do |result, error|
      if error
        raise "There was an error when updating Gmail thread labels."
      else
        thread.messages.find_each do |message|
          message.google_label_ids = result.messages.first.try(:label_ids) || []
        end
      end

    end
  end

end
