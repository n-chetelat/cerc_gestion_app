module Api
  module Phases
    class PersonsController < ApiController
      before_action :authorize_gmail, only: [:update]
      before_action :set_resource
      after_action :broadcast_changes, only: [:update]

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/persons/person"
        @resource_name = :person
      end

      def update
        email_labels = PhaseService.prepare_email_label_lists(@resource, @phase)
        PhaseService.place_person_in_phase(@resource,
          @phase, request)
        PhaseService.update_email_labels_for(@resource, email_labels[:add_label_ids],
          email_labels[:remove_label_ids], request)
        render :show
      end

      private

        def set_resource
          @phase ||= Phase.find_by(uuid: params[:phase_id])
          @resource ||= Person.find_by(uuid: params[:id])
          @old_phase ||= @resource.current_phase
        end

        def broadcast_changes
          slugs = @old_phase.boards.pluck(:slug) + @phase.boards.pluck(:slug)
          BoardChannel.send_phases_update(slugs)
        end

    end
  end
end
