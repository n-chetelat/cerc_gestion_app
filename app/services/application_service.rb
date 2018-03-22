class ApplicationService

  def self.create_application(params)
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
        if field.form.to_s =~ /upload_/ # files need to be stored differently
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
        return application
      end
    end
  end

end
