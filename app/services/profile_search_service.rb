class ProfileSearchService

  def self.filter_profiles_by_query_string(query_str)
    return Person.none if query_str.blank?
    person_ids = self.get_person_ids_from_query(query_str)
    Person.post_recruitment.where(id: person_ids)
  end

  # private

    def self.get_person_ids_from_query(query_str)
      query_components = query_str.split(";")

      column_result_person_ids = []
      search_str_result_person_ids = []
      search_strs = []

      query_components.each do |component|
        if component.scan(/:{2}/).any? # column name is specified
          if column_result_person_ids.empty?
            column_result_person_ids = self.get_column_results_person_ids(component)
          else
            column_result_person_ids &= self.get_column_results_person_ids(component)
          end
        else # no column name is specified - looks only in name, lastname, position
          search_strs << component
        end
      end

     if search_strs.any?
       search_str_result_person_ids =
        self.get_search_str_results_person_ids(search_strs.compact.join(" "))
     end

     if search_str_result_person_ids.any? && column_result_person_ids.any?
       # Take intersection of person id arrays
       person_ids = (column_result_person_ids & search_str_result_person_ids)
     elsif search_str_result_person_ids.empty? && column_result_person_ids.empty?
       person_ids = []
     else
       person_ids = (search_str_result_person_ids.any?) ? search_str_result_person_ids
        : column_result_person_ids
     end
      person_ids
    end



    def self.get_search_str_results_person_ids(query_str)
      query_strs = query_str.split.map {|str| "%#{str.strip}%"}
      position_ids = Position.translation_class.where(locale: :en)
        .where("lower(title) ILIKE any (array[?])", query_strs)
        .select(:position_id)

      sql = "name ILIKE any (array[?]) OR lastname ILIKE any (array[?])"\
        " OR applications.position_id IN (?)"
      vars = [query_strs, query_strs, position_ids]

      Person.post_recruitment.where(sql, *vars).pluck(:id)
    end



    def self.get_column_results_person_ids(query_str)
      column_title, value = query_str.split("::").map {|s| s.strip }
      column_title.downcase!
      column = ProfileField.find_by("lower(label) = ?", column_title)
      return [] unless value.present?

      if column
        field_ids = self.get_column_results_for_dynamic_fields(column, value)
        person_ids = Person.post_recruitment.joins(:persons_profile_fields)
          .where("persons_profile_fields.id IN (?)", field_ids)
          .pluck("persons.id")
      else
        person_ids = self.get_column_results_for_static_fields(column_title, value)
      end

      person_ids
    end



    def self.get_column_results_for_static_fields(column_title, value)

      persons = case column_title
      when "position"
        position_id = Position.translation_class.where(locale: :en)
          .find_by("lower(title) = ?", value).try(:position_id)
         Person.post_recruitment.where("applications.position_id = ?", position_id)

      when "starting date", "ending date"
        date = Date.parse(value) rescue nil
        is_semester = false

        if date.nil? # Try for semester-based date
          date = ::DatesService.semester_label_to_date(value)
          is_semester = true
        end

        return [] unless date
        operator = (["<", ">"].include?(value[0]) ? value[0] : "=")

        if operator == "<" && is_semester
          date = date - 1.day
        end

        if /starting/.match(column_title)
          attr_name = "starting_date"
        elsif /ending/.match(column_title)
          attr_name = "ending_date"
        else
          return Person.none
        end

        Person.post_recruitment.where("applications.#{attr_name}::date #{operator} ?", date)

      when "application sent on", "application closed on"
        date = Date.parse(value) rescue nil
        return [] unless date
        operator = (["<", ">"].include?(value[0]) ? value[0] : "=")

        if /sent/.match(column_title)
          attr_name = "created_at"
        elsif /closed/.match(attr_name)
          attr_name = "closed_at"
        else
          return Person.none
        end

        sql = "applications.#{attr_name}::date #{operator} ? "\
          " AND applications.created_at::date != applications.closed_at::date"

        Person.post_recruitment.where(sql, date)

      when "name", "lastname", "email"
        Person.post_recruitment.where("#{column_title} ILIKE ?", value)
      else
        []
      end
      person_ids = persons.pluck("persons.id")

    end



    def self.get_column_results_for_dynamic_fields(column, value)

      field_ids = case column.form
      when :text, :textarea
        field_ids = column.persons_profile_fields
          .where("lower(persons_profile_fields.data::text) @@ ?", value.downcase)
          .select("persons_profile_fields.id")

      when :date, :month
        date = Date.parse(value) rescue nil
        return [] unless date
        operator = (["<", ">"].include?(value[0]) ? value[0] : "@>")
        # This query compares strings, not dates. Date casting with to_date() PG method was not working.
        field_ids = column.persons_profile_fields
          .where("persons_profile_fields.data #{operator} :date AND NOT (persons_profile_fields.data ? '')", date: date.to_json)
          .select("persons_profile_fields.id")

      when :semester
        first_date = ::DatesService.semester_label_to_date(value)
        return [] if first_date.nil?
        months = ::DatesService.get_months_in_semester(first_date)
        last_date = Date.parse("#{first_date.year}-#{months.last}-01")
        last_date = last_date.end_of_month

        field_ids = column.persons_profile_fields
          .where("persons_profile_fields.data >= :first_date AND persons_profile_fields.data <= :last_date",
            first_date: first_date.to_json, last_date: last_date.to_json)
          .select("persons_profile_fields.id")

      when :radio, :select
        choices = column.choices_with_locale(:en)
        choice_options = choices.find do |ch|
          ch[:label].downcase == value.downcase
        end
        return [] unless choice_options
        choice_id = choice_options[:id]

        field_ids = column.persons_profile_fields
          .where("persons_profile_fields.data ?| array[:keys]", keys: [choice_id])
          .select("persons_profile_fields.id")

      when :checkbox
        choices = column.choices_with_locale(:en)
        choice_options = choices.find do |ch|
          ch[:label].downcase == value.downcase
        end
        return [] unless choice_options
        choice_ids = choice_options[:id]

        field_ids = ProfileField.where(form_cd: [6]).joins(:persons_profile_fields)
          .where("persons_profile_fields.data ?| array[:keys]", keys: choice_ids)
          .select("persons_profile_fields.id")

      else
        field_ids = []
      end

      field_ids
    end


end
