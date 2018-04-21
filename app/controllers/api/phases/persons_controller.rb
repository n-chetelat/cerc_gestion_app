module Api
  module Phases
    class PersonsController < ApiController
      before_action :authorize_gmail, only: [:update]
      before_action :set_resource

      def update
        PhaseService.place_person_in_phase(@resource,
          @phase, request)
        render :show
      end

      def partial_path
        "api/persons/person"
      end

      def resource_name
        :person
      end

      private

        def set_resource
          @phase ||= Phase.find_by(uuid: params[:phase_id])
          @resource ||= Person.find_by(uuid: params[:id])
        end

    end
  end
end
