module Api
  class PersonsController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show,:update, :destroy]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/persons/person"
      @resource_name = :person
    end

    def index
      @resources = Person.all
    end

    def show
    end

    def update
      @resource.update(permitted_params)
      if params[:profile]
        render partial: "api/profiles/profile", locals: {person: @resource}
      else
        render :show
      end
    end

    def destroy
      @resource.destroy!
      render :show
    end

    private

      def set_resource
        @resource = Person.find_by(uuid: params[:id])
      end

      def permitted_params
        params.permit(:name, :lastname, :email, :finished_at)
      end

  end
end
