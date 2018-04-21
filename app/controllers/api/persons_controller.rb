module Api
  class PersonsController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show,:update, :delete]

    def index
      @resources = Person.all
    end

    def show
    end

    def update
      render :show
    end

    def delete
      @resource.destroy
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
        @resource = Person.find_by(uuid: params[:id])
        @scopes = params[:scopes].try(:values) || []
      end

  end
end
