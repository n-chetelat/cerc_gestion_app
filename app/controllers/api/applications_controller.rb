module Api
  class ApplicationsController < ApiController
    before_action :set_resource, only: [:show,:update, :delete]

    def index
      @resources = Application.all
    end

    def show
    end

    def create
      @resource = Application.new
      ApplicationService.build_application(@resource, params)
      if @resource.save
        render :show
      else
        render json: {
          error: "There was an error when creating the application", status: 500
          }, status: 500
      end
    end

    def update
      render :show
    end

    def delete
      @resource.destroy
      render :show
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
