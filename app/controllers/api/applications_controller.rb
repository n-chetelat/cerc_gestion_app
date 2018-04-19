module Api
  class ApplicationsController < ApiController
    before_action :set_resource, only: [:show,:update]
    before_action :authorize_gmail, only: [:create]

    def index
      @resources = Application.all
    end

    def show
      @form_fields = ::ApplicationService.fields_to_hash_for(@resource)
    end

    def create
      if @resource = ApplicationService.create_application(params)
        PhaseService.place_person_in_phase(@resource.person, Phase.current_initial, request)
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

  end
end
