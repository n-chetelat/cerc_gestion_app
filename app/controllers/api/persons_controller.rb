module Api
  class PersonsController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show, :destroy]

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

    def destroy
      @resource.destroy!
      render :show
    end


    private

      def set_resource
        @resource = Person.find_by(uuid: params[:id])
      end

  end
end
