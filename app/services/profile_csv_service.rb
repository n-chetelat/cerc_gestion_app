class ProfileCsvService

  MANDATORY_FIELDS = ["name", "lastname", "status"]
  PERSON_FIELDS = ["email"]
  APPLICATION_FIELDS = ["starting_date", "ending_date", "applied_at", "closed_at"]

  def initialize(profile_ids, field_ids)
    @profile_ids = profile_ids || []
    @field_ids = field_ids || []

    @filtered_profiles = get_filtered_profiles

    static_field_ids = get_filtered_static_fields
    @person_field_ids = static_field_ids[:person]
    @application_field_ids = static_field_ids[:application]

    @dynamic_fields = get_filtered_dynamic_fields
  end

  def generate_csv_file_structure
    with_position = @field_ids.include?("position_id")

    headers = (with_position ? ["Position"] : []) + @person_field_ids +
      @application_field_ids + @dynamic_fields.pluck(:label)

    lines = @filtered_profiles.map do |person|
      position = with_position ? [person.position.title] : []
      person_fields = @person_field_ids.map {|f| person.send(f) }
      application = person.application
      application_fields = @application_field_ids.map {|f| value = application.send(f) }
      dynamic_fields = @dynamic_fields.map {|f| get_text_value_for_field(person, f) }

      position + person_fields + application_fields + dynamic_fields
    end

    {headers: headers, lines: lines}
  end

  private

    def get_filtered_profiles
      unless @profile_ids.try(:any?)
        @profile_ids = Person.post_recruitment.pluck(:id)
      end
      Person.post_recruitment.where(id: @profile_ids)
    end

    def get_filtered_static_fields
      static_field_ids = @field_ids
      unless static_field_ids.try(:any?)
        static_field_ids = PERSON_FIELDS + APPLICATION_FIELDS
      end
      static_field_ids = static_field_ids.select {|field| !(/^\d+$/.match(field)) }
      {
        person: MANDATORY_FIELDS + (static_field_ids & PERSON_FIELDS),
        application: (static_field_ids & APPLICATION_FIELDS)
      }
    end

    def get_filtered_dynamic_fields
      field_ids = @field_ids
      unless field_ids.try(:any?)
        field_ids = ProfileField.all.pluck(:id)
      end
      field_ids = field_ids.select {|field| /^\d+$/.match(field.to_s) }.map(&:to_i)
      ProfileField.where(id: field_ids)
    end

    def get_text_value_for_field(person, profile_field)
      person_field = person.persons_profile_fields.find_by(profile_field_id: profile_field.id)
      return unless person_field
      value = person_field.data
      case person_field.form
      when :textarea
        value.dump
      when :text, :date
        value.blank? ? nil : value
      when :month
        DatesService.month_to_s(value)
      when :semester
        DatesService.semester_to_s(value)
      when :radio, :select
        profile_field.locale_choices[value]["en"]
      when :checkbox
        value.map {|val| profile_field.locale_choices[val]["en"] }.join(" / ")
      else
        nil
      end
    end

end
