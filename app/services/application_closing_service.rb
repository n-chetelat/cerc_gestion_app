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

  def create_default_end_date
    return unless @application.ending_date.nil?
    
    duration = (@application.position.duration_units || 2) - 1 # default value of 2 is arbitrary
    time_interval = @application.position.time_interval
    starting_date = @application.starting_date


    if time_interval == :semester
      semesters = ::DatesService::SEMESTERS_MONTHS.values
      index = semesters.find_index(starting_date.month)
      raise "invalid starting date for interval type" unless index
      # put starting date month number at beginning of array
      index.times { semesters.push(semesters.shift) }
      end_date_semester = semesters[(duration % semesters.size)]
      end_date_year = starting_date.year + ((duration + index) / semesters.size)
      end_date = Date.parse("#{end_date_year}-#{end_date_semester}-01")
    elsif time_interval == :month
      end_date = starting_date + duration.months
    else
      raise "invalid time interval for position"
    end

    @application.ending_date = end_date
    @application.save!
  end

  def create_person_position_milestones
    milestones = @application.position.milestones
    milestones.order(time_interval_ordinality: :asc).each do |milestone|
      person_milestone = PersonPositionsMilestone.find_or_initialize_by(
        person_id: @person.id,
        positions_milestone_id: milestone.id
      )
      if person_milestone.new_record?
        person_milestone.calculate_date_for_milestone!
        person_milestone.save
      end
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
