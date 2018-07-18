module Api
  module Persons
    class PositionsMilestonesController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_person, only: [:index]

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/persons/positions_milestone"
        @resource_name = :person_milestone
      end

      def index
        @resources = @person.persons_positions_milestones
      end

      private

        def set_person
          @person ||= Person.find_by(uuid: params[:person_id])
        end

    end
  end
end
