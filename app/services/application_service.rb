class ApplicationService

  def self.create_application(params)
    begin
      Application.new.with_lock do
        person = self.set_person_attributes(Person.new, params)
        application = person.application || person.build_application
        self.set_application_common_attributes(application, params)
        self.set_form_fields(application, params)
        application.locale = I18n.locale
        application.save!
        application
      end
    rescue
      nil
    end
  end

  def self.update_application(application, params)
    begin
      application.with_lock do
        person = self.set_person_attributes(application.person, params)
        self.set_application_common_attributes(application, params)
        self.set_form_fields(application, params)
        application.save!
        application
      end
    rescue
      nil
    end
  end

  def self.fields_to_hash_for(application)
    custom_fields = application.fields_for_current_position.map do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      form_field = Positions::FormField.find_by(id: form_field_id.to_i)
      next unless form_field
      self.field_to_hash(form_field, value)
    end.compact
    common_fields = Positions::RecruitmentForm.common_fields.map do |field|
      {form_field_id: field[:id], label: field[:label],
        type: field[:type].split("input-").last, value: application.person.send(field[:id])}
    end
    position = [
      {form_field_id: "position_id", label: "Position", type: "select",
        value: application.position_id}
    ]
    position + common_fields + custom_fields
  end

  private

    def self.set_person_attributes(person, params)
      person_attributes = {}
      common_fields = Positions::RecruitmentForm.common_fields.reject {|field| field[:id] == "starting_semester"}
      common_field_names = common_fields.map do |attr|
        field_name = "#{attr[:type].gsub(/-/, "_")}_#{attr[:id]}"
        person_attributes[attr[:id]] = params.delete(field_name)
      end

      person.email =  person_attributes["email"]
      person.attributes = person_attributes.compact
      person.save!
      person
    end

    def self.set_application_common_attributes(application, params)
      position_id = params[:input_select_position_id]
      position = Position.find(position_id)
      starting_semester = params.delete(:input_select_starting_semester)

      application.position = position
      application.starting_semester = starting_semester
    end

    def self.set_form_fields(application, params)
      form_fields = application.position.recruitment_form.form_fields
      form_fields.each do |field|
        attribute_name = "input_#{field.form}_#{field.id}"
        attribute = params[attribute_name]
        if attribute.nil?
          application.fields[attribute_name] = nil
        elsif field.form.to_s =~ /upload_/ # files need to be stored differently
          if attribute.class == ActionController::Parameters
            application.fields[attribute_name] ||= []
            # Remove unused saved uploads
            application.fields[attribute_name].select! do |attr|
              attribute.values.include?(GlobalID::Locator.locate(attr["uri"]).try(:file_name))
            end
            # Add new uploads
            attribute.values.each do |upload|
              next if upload.is_a?(String)
              file = Attachment.create!(file: upload)
              application.fields[attribute_name] << file.to_global_id
            end
          else
            unless attribute.is_a?(String)
              file = Attachment.create!(file: attribute)
              application.fields[attribute_name] = file.to_global_id
            end
          end
        elsif attribute.class == ActionController::Parameters # many values under same field name
          application.fields[attribute_name] = attribute.values
        else
          application.fields[attribute_name] = attribute
        end
      end
    end

    def self.field_to_hash(form_field, value)
      attrs = {form_field_id: form_field.id, label: form_field.label, type: form_field.form}
      attrs[:value] = case form_field.form
      when :text, :textarea, :date, :radio, :select, :checkbox
        value
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
