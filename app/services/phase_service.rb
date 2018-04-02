class PhaseService

  def self.apply_callbacks_for(person, phase, google_service)
    phase.phases_callbacks.each do |callback|
      if template = callback.email_template
        google_service.send_email_to(person, template)
      end
    end
  end

end
