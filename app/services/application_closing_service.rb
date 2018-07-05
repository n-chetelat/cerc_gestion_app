class ApplicationClosingService

  def initialize(application)
    unless application.closed_at
      raise "Application must be closed in order to create a profile for applicant."
    end
    @application = application
    @application_form = application.position.recruitment_form
    @person = application.person
  end

  # Put applicant information in profile fields whether application
  # was accepted or not
  def store_application_fields_in_profile_fields
    ActiveRecord::Base.transaction do
      @application_form.form_fields.without_uploads.each do |application_field|
        unless profile_field = ProfileField.find_by(label: application_field.label(:en),
            form_cd: application_field.form_cd)
          profile_field = create_profile_field_from(application_field)
        end
        person_profile_field = profile_field.persons_profile_fields.build(
          person_id: @person.id,
          data: @application.fields[application_field.input_field_generated_id]
        )
        person_profile_field.save!
      end
    end
  end

  def create_person_position_milestones
    milestones = @application.position.milestones
    milestones.order(time_interval_ordinality: :asc).each do |milestone|
      person_milestone = PersonPositionsMilestone.find_or_initialize_by(
        person_id: @person.id,
        positions_milestone_id: milestone.id
      )
      person_milestone.calculate_date_for_milestone! if person_milestone.date.nil?
      person_milestone.save
    end
  end

  private

    def create_profile_field_from(application_field)
      field_attrs = application_field.attributes.symbolize_keys.slice(
        :form_cd, :optional, :options)
      profile_field = ProfileField.new(field_attrs.merge({
        label: application_field.label(:en)
      }))
      if profile_field.save
        profile_field
      else
        nil
      end
    end

end
