module Api
  class ProfilesController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/profiles/profile"
      @resource_name = :person
    end

    def index
      @resources = Person.active
    end

  end
end
