class ApplictionClosingService

  def initiliaze(application)
    @application = application
    @application_form = application.position.recruitment_form
    @person = application.person
  end

  # Detect if applicant's form fields have already been made into profile fields.
  # Create new fields if necessary
  def create_profile_fields_for_application
    to_create = @application_form.form_fields.where.not(
      id: ProfileField.select(:form_field_id))

    return if to_create.empty?

    transaction do
      to_create.each do |application_field|
        field_attrs = application_field.attributes.symbolize_keys.slice(
          :form_cd, :optional, :options)
        profile_field = ProfileField.new(field_attrs.merge(
          label: application_field.label(:en),
          form_field_id: application_field.id
        ))
        profile_field.save!
      end
    end
  end

  # Put applicant information in profile fields whether application
  # was accepted or not
  def store_application_fields_in_profile_fields
    @application_form.form_fields.each do |field|

    end
  end

end
