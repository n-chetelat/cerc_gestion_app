class ProfileSearchService

  def self.filter_profiles_by_query_string(query_str)
    Person.active.limit(2)
  end

end
