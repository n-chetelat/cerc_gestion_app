module Api
  class PersonsController < ApiController
    before_action :set_resource, only: [:show,:update, :delete]

    def index
      @resources = Person.all
    end

    def show
      # preload correspondence with person
      token = SecureRandom.base58(24)
      Redis.current.set("email-fetch-#{@resource.id}", token)
      EmailWorker.perform_async(@resource.id)
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
        @resource = Person.find(params[:id])
        @scopes = params[:scopes].try(:values) || []
      end

  end
end
