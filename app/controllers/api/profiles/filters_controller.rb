module Api
  module Profiles
    class FiltersController < ApiController

      attr_reader :partial_path, :resource_name
      def initialize
        @partial_path = "api/profiles/profile"
        @resource_name = :person
      end

      def index
        @resources = []
        if params[:q].try(:strip)
          @resources = ::ProfileSearchService.filter_profiles_by_query_string(params[:q])
        end
      end


    end
  end
end
