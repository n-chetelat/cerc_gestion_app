module Api
  class ProfilesController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/profiles/profile"
      @resource_name = :person
    end

    def index
      @resources = Person.active
    end

    def update
      field = PersonProfileField.find_by(id: params[:id])
      field.data = params[:data]
      if field.save
        @resource = field.person
        render :show
      else
        raise "Pofile information cannot be updated"
      end
    end

  end
end
