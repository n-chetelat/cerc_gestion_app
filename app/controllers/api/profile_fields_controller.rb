module Api
  class ProfileFieldsController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/profile_fields/profile_field"
      @resource_name = :profile_field
    end

    def index
      @resources = ProfileField.all
    end

  end
end
