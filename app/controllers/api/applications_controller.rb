module Api
  class ApplicationsController < ApiController
    before_action :set_resource, only: [:show,:update]
    before_action :authorize_gmail, only: [:create]
    after_action :broadcast_changes, only: [:create, :update]

    def index
      @resources = Application.all
    end

    def show
      @form_fields = ::ApplicationService.fields_to_hash_for(@resource)
    end

    def create
      if @resource = ApplicationService.create_application(params)
        email_labels = PhaseService.prepare_email_label_lists(@resource.person, Phase.current_initial)

        PhaseService.place_person_in_phase(@resource.person, Phase.current_initial, request)
        PhaseService.apply_automatic_callbacks_for(@resource.person, Phase.current_initial, request)
        PhaseService.update_email_labels_for(@resource.person, email_labels[:add_label_ids],
          email_labels[:remove_label_ids], request)
      else
        render json: {
          error: "There was an error when creating the application", status: 500
          }, status: 500
      end
    end

    def update
      if @resource = ApplicationService.update_application(@resource, params)
        render :show
      else
        render json: {
          error: "There was an error when updating the application", status: 500
          }, status: 500
      end
    end

    def partial_path
      "api/applications/application"
    end

    def resource_name
      :application
    end


    private

      def set_resource
        @resource = Application.find(params[:id])
      end

      def broadcast_changes
        slugs = @resource.person.current_phase.boards.pluck(:slug)
        BoardChannel.send_phases_update(slugs)
      end

  end
end
