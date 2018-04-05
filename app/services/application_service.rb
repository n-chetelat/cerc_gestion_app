class ApplicationService

  def self.create_application(params)

    begin
      Application.new.with_lock do
        # Separate out hard-coded attributes
        position = Position.find(params[:position_id])
        starting_semester = params.delete(:input_select_starting_semester)

        person_attributes = {}
        common_field_names = Positions::RecruitmentForm.common_fields.map do |attr|
          field_name = "#{attr[:type].gsub(/-/, "_")}_#{attr[:id]}"
          person_attributes[attr[:id]] = params.delete(field_name)
        end

        # Create profile from name and email info
        person = Person.find_or_create_by(email: person_attributes["email"])
        person.attributes = person_attributes.compact

        application = person.application || person.build_application

        # Populate pre-defined application attributes
        application.position = position
        application.starting_semester = starting_semester
        application.locale = I18n.locale

        # Populate application data from form fields (not pre-defined)
        form_fields = application.position.recruitment_form.form_fields
        form_fields.each do |field|
          attribute_name = "input_#{field.form}_#{field.id}"
          attribute = params[attribute_name]
          if attribute.nil?
            application.fields[attribute_name] = nil
          elsif field.form.to_s =~ /upload_/ # files need to be stored differently
            if attribute.class == ActionController::Parameters
              attribute.values.each do |upload|
                file = Attachment.create!(file: upload)
                application.fields[attribute_name] ||= []
                application.fields[attribute_name] << file.to_global_id
              end
            else
              file = Attachment.create!(file: attribute)
              application.fields[attribute_name] = file.to_global_id
            end
          elsif attribute.class == ActionController::Parameters # many values under same field name
            application.fields[attribute_name] = attribute.values
          else
            application.fields[attribute_name] = attribute
          end
        end

      if person.save!

        # Classify person under initial phase if there is one
        if initial = Phase.current_initial
          PersonPhase.create!(person: person, phase: initial)
        end

        return application
      end
    end

    rescue
      false
    end
  end

  def self.send_receipt_confirmation_email(person, google_service)
    initial = Phase.current_initial
    PhaseService.apply_callbacks_for(person, initial, google_service)
  end

  def self.fields_to_hash_for(application)
    application.fields.map do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      form_field = Positions::FormField.find(form_field_id.to_i)
      next unless form_field
      self.field_to_hash(form_field, value)
    end.compact
  end

  private

    def self.field_to_hash(form_field, value)
      attrs = {form_field_id: form_field.id, label: form_field.label, type: form_field.form}
      attrs[:value] = case form_field.form
      when :text, :textarea, :date
        value
      when :radio, :select
        form_field.locale_choices[value].try(:[], I18n.locale.to_s)
      when :checkbox
        (value || []).map do |val|
          form_field.locale_choices[val][I18n.locale.to_s]
        end
      when :upload_single
        if value
          file = GlobalID::Locator.locate(value["uri"])
          {name: file.file.name, url: file.file.url}
        else
          {name: nil, url: nil}
        end
      when :upload_multiple
        (value || []).map do |val|
          file = GlobalID::Locator.locate(val["uri"])
          {name: file.file.name, url: file.file.url}
        end
      else
        nil
      end
      attrs
    end



end
