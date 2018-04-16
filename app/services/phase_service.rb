class PhaseService

  def self.place_person_in_phase(person, phase, request)
    return if phase.nil? || person.nil?

    old_phase_label_id = person.current_phase.try(:email_label).try(:google_label_id)
    new_phase_label_id = phase.email_label.try(:google_label_id)

    person_phase = PersonPhase.find_or_initialize_by(person: person)
    person_phase.phase = phase
    person_phase.save!

    self.update_email_labels_for(person, [new_phase_label_id], [old_phase_label_id], request)
    self.apply_callbacks_for(person, phase, request)
  end

  def self.update_email_labels(phase, add_label_ids, remove_label_ids, request)
    phase.persons.each do |person|
      self.update_email_labels_for(person, add_label_ids, remove_label_ids, request)
    end
  end

  def self.update_email_labels_for(person, add_label_ids, remove_label_ids, request)
    if person.threads.any?
      email_service = ::EmailService.new(request)
      person.threads.each do |thread|
        email_service.update_thread_labels(thread, add_label_ids, remove_label_ids)
      end
    end
  end

  def self.apply_callbacks_for(person, phase, request)
    phase.phases_callbacks.each do |callback|
      if template = callback.email_template
        compiled_email = template.compile_with_vars(person)

        mail = Mail.new do
          to person.email
          subject compiled_email.subject
        end
        text_part = Mail::Part.new do
          body compiled_email.plain
        end
        html_part = Mail::Part.new do
          content_type "text/html; charset=UTF-8"
          body compiled_email.body
        end
        mail.text_part = text_part
        mail.html_part = html_part

        mail_options = {
          thread_id: person.threads.order(created_at: :desc).try(:first).try(:google_thread_id)
        }
        ::EmailService.new(request).send_email_to(mail, mail_options)
      end
    end
  end


end
