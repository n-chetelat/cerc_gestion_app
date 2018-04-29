module Api
  module Phases
    class PersonsController < ApiController
      before_action :authorize_gmail, only: [:update, :archive]
      before_action :set_resource

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/persons/person"
        @resource_name = :person
      end

      def update
        PhaseService.place_person_in_phase(@resource,
          @phase, request)
        render :show
      end

      private

        def set_resource
          @phase ||= Phase.find_by(uuid: params[:phase_id])
          @resource ||= Person.find_by(uuid: params[:id])
        end

    end
  end
end
