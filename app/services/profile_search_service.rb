class ProfileSearchService

  def self.filter_profiles_by_query_string(query_str)
    return Person.none if query_str.blank?
    query = self.parse_query_string_into_sql(query_str)
    Person.accepted.where(query[:sql], *query[:vars])
  end

  # private

    def self.parse_query_string_into_sql(query_str)
      query_components = query_str.split(";")
      search_str_sql_components = []
      column_sql_components = []
      query_components.each do |component|
        component.strip!
        if component.scan(/:{2}/) # no column name is specified
          search_str_sql_components << component
        else
          column_sql_components << self.make_column_search_sql(compenent)
        end
      end

     if search_str_sql_components.any?
       self.make_string_search_sql(search_str_sql_components.joins(" "))
      end

      column_sql_components.compact!
      column_sql = column_sql_components.map {|c| c[:sql] }.join(" OR ")
      sql = [search_str_sql[:sql], column_sql].map {|c| c.presence}.compact.join(" AND ")
      column_vars = column_sql_components.map {|c| c[:vars].flatten }.compact
      vars = search_str_sql[:vars] + column_vars
      {sql: sql, vars: vars}
    end

    def self.make_string_search_sql(query_str)
      query_strs = query_str.split.map {|str| "%#{str.strip}%"}
      position_ids = Position.translation_class.where(locale: :en)
        .where("title ILIKE any (array[?])", query_strs)
        .select(:id)

      sql = "name ILIKE any (array[?]) OR lastname ILIKE any (array[?])"\
        " OR applications.position_id IN (?)"
      vars = [query_strs, query_strs, position_ids]
      {sql: sql, vars: vars}
    end

    def self.make_column_search_sql(query_str)
      column_title, value = query_str.split("::").map {|s| s.strip }
      return unless column = ProfileField.find_by(label: column_title)

      field_ids = case column.form
      when :text, :textarea
        field_ids = ProfileField.where(form_cd: [0,1]).joins(:persons_profile_fields)
          .where("lower(persons_profile_fields.data::text) @@ ?", value.downcase)
          .select("persons_profile_fields.id")
        when :date, :month
          date = Date.parse(value)
          operator = (["<", ">"].include?(value[0]) ? value[0] : "LIKE")
          # This query compares strings, not dates. Date casting with to_date() PG method was not working.
          field_ids = ProfileField.where(form_cd: [4,8]).joins(:persons_profile_fields)
            .where("persons_profile_fields.data::varchar #{operator} :date AND persons_profile_fields.data::varchar != :date",
              date: date.to_s)
            .select("persons_profile_fields.id")
        when :semester
          first_date = ::DatesService.semester_label_to_date(value)
          months = ::DatesService.get_months_in_semester(first_date)
          last_date = Date.parse("#{first_date.year}-#{months.last}-01")
          last_date = last_date.end_of_month

          field_ids = ProfileField.where(form_cd: [9]).joins(:persons_profile_fields)
            .where("persons_profile_fields.data::varchar < :first_date AND persons_profile_fields.data::varchar > :last_date",
              first_date: first_date.to_s, last_date: last_date.to_s)
            .select("persons_profile_fields.id")
        when :radio
          choices = column.choices_with_locale(:en)
          choice_options = choices.find do |ch|
            ch[:label].downcase == value.downcase
          end
          return unless choice_options
          choice_id = choice_options[:id]

          field_ids = ProfileField.where(form_cd: [7]).joins(:persons_profile_fields)
            .where("persons_profile_fields.data::varchar = ?", choice_id)
            .select("persons_profile_fields.id")
        when :checkbox, :select
          choices = column.choices_with_locale(:en)
          choice_options = choices.find do |ch|
            ch[:label].downcase == value.downcase
          end
          return unless choice_options
          choice_id = choice_options[:id]

          field_ids = ProfileField.where(form_cd: [5,6]).joins(:persons_profile_fields)
            .where("persons_profile_fields.data && (?)", choice_id)
            .select("persons_profile_fields.id")

            # .where("array[persons_profile_fields.data] && array[?::jsonb] or true", ["1"]).pluck("array[persons_profile_fields.data]")

      else
        []
      end

      Person.post_recruitment.joins(:persons_profile_fields)
        .where("persons_profile_fields.id IN (?)", field_ids)
    end

end
