class PhaseService

  def self.apply_callbacks_for(person, phase, request)
    phase.phases_callbacks.each do |callback|
      if template = callback.email_template
        google_service = GoogleService.new(request)
        google_service.send_email_to(person, template)
      end
    end
  end

end
