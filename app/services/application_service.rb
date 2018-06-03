class ApplicationService
  require 'zip'

  ZIP_PATH = "tmp/application_uploads"

  def self.create_application(params)
    Application.transaction do
      person = self.set_person_attributes(Person.new, params)
      application = person.application || person.build_application
      self.set_application_common_attributes(application, params)
      self.set_form_fields(application, params)
      application.locale = I18n.locale
      application.save!
      application
    end
  end

  def self.update_application(application, params)
    application.with_lock do
      person = self.set_person_attributes(application.person, params)
      self.set_application_common_attributes(application, params)
      self.set_form_fields(application, params)
      application.save!
      application
    end
  end

  def self.fields_to_hash_for(application)
    custom_fields = application.fields_for_current_position.map do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      form_field = Positions::FormField.find_by(id: form_field_id.to_i)
      next unless form_field
      self.field_to_hash(form_field, value)
    end.compact
    common_fields = application.position.recruitment_form.common_fields.map do |field|
      {form_field_id: field[:id], label: field[:label],
        type: field[:type].split("input-").last, value: application.person.send(field[:id])}
    end
    position = [
      {form_field_id: "position_id", label: "Position", type: "select",
        value: application.position_id}
    ]
    position + common_fields + custom_fields
  end

  def self.fields_to_plain_text_for(application)
    custom_fields = application.fields_for_current_position.map do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      form_field = Positions::FormField.find_by(id: form_field_id.to_i)
      next unless form_field
      self.field_to_plain_text(form_field, value)
    end.compact

    common_fields = application.position.recruitment_form.common_fields.map do |field|
      next if field[:id] == "starting_date"
      {label: field[:label], value: application.person.send(field[:id])}
    end.compact

    other_fields = [
      {label: "Position", value: application.position.title},
      {label: "Starting on", value: application.starting_date_to_s}
    ]

    other_fields + common_fields + custom_fields
  end

  def self.email_application_materials(application, request)

    mail = Mail.new do
      subject "Application materials for #{application.person.full_name}"
      to ENV["GMAIL_ADDRESS"]
      from ENV["GMAIL_ADDRESS"]
    end
    fields = self.fields_to_plain_text_for(application)
    text_part = Mail::Part.new do
      body ApplicationController.new.helpers.render_template("application_materials_mailer/send_application_materials.text.erb",
        application: application,
        fields: fields
      )
    end
    html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body ApplicationController.new.helpers.render_template("application_materials_mailer/send_application_materials.html.erb",
        application: application,
        fields: fields
      )
    end

    mail.text_part = text_part
    mail.html_part = html_part

    if application.attachments.any?
      Dir.mkdir(ZIP_PATH) unless Dir.exists?(ZIP_PATH)
      filename = "#{application.person.full_name.parameterize}-#{application.id}"
      path = "#{ZIP_PATH}/#{filename}.zip"
      self.zip_application_uploads(application, path)

      mail.add_file(path)
    end

    ::EmailService.new(request).send_email_to(mail, {do_not_save_thread: true})

    File.delete(path) if path
  end


  private

    def self.zip_application_uploads(application, zipfile_name)
      return if (attachments = application.attachments).empty?

      zip_file = Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        attachments.each do |attachment|
          begin
            zipfile.add(attachment.file_name, attachment.file.path)
          rescue Zip::EntryExistsError
            next
          end
        end
      end
    end

    def self.set_person_attributes(person, params)
      person_attributes = {}
      Positions::RecruitmentForm.immutable_common_fields.map do |attr|
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
      starting_date = params.delete(:input_select_starting_date)

      application.position = position
      application.starting_date = starting_date
    end

    def self.set_form_fields(application, params)
      form_fields = application.position.recruitment_form.form_fields

      unless self.validate_form_fields(form_fields, params)
        raise "One or more fields in the application are invalid."
      end

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

    def self.validate_form_fields(form_fields, params)
      all_valid = form_fields.all? do |field|
        attribute_name = "input_#{field.form}_#{field.id}"
        value = params[attribute_name]
        next true if value.nil?

        valid = case field.form
          when :upload_multiple
            value.respond_to?(:each) && value.values.all? do |upload|
              upload.is_a?(String) ||
              upload.is_a?(ActionDispatch::Http::UploadedFile) &&
              upload.content_type == "application/pdf"
            end
          when :upload_single
            value.is_a?(String) ||
            value.is_a?(ActionDispatch::Http::UploadedFile) &&
              value.content_type == "application/pdf"
          when :text, :textarea
            value.is_a?(String)
          when :date
            !!(Date.parse(value) rescue false)
          when :select, :radio
            field.locale_choices.keys.include?(value)
          when :month, :semester
            field.choices_with_locale.map {|ch| ch[:id].to_s }.include?(value)
          when :checkbox
            value.respond_to?(:each) && value.values.all? do |check|
              field.locale_choices.keys.include?(check)
            end
        end
        valid
      end
      all_valid
    end

    def self.field_to_hash(form_field, value)
      attrs = {form_field_id: form_field.id, label: form_field.label, type: form_field.form}
      attrs[:value] = case form_field.form
      when :text, :textarea, :date, :radio, :select, :checkbox, :month, :semester
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

    def self.field_to_plain_text(form_field, value)
      attrs = {label: form_field.label}
      attrs[:value] = case form_field.form
      when :text, :textarea, :date
        value
      when :date
        value.to_formatted_s(:long)
      when :radio, :select
        form_field.locale_choices[value].try(:[], I18n.locale.to_s)
      when :month, :semester
        item = form_field.choices_with_locale.find {|ch| ch[:id].to_s == value}
        item[:label]
      when :checkbox
        (value || []).map do |val|
          form_field.locale_choices[val][I18n.locale.to_s]
        end
      when :upload_single
        if value
          file = GlobalID::Locator.locate(value["uri"])
          file.file.name
        else
          nil
        end
      when :upload_multiple
        (value || []).map do |val|
          file = GlobalID::Locator.locate(val["uri"])
          file.file.name
        end
      else
        nil
      end

      attrs
    end



end
