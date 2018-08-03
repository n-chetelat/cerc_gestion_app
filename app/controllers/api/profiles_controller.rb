module Api
  class ProfilesController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show, :update, :destroy]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/profiles/profile"
      @resource_name = :person
    end

    def index
      @resources = Person.post_recruitment
    end

    def show
    end

    def create
      @resource = Person.new(permitted_params)
      application = @resource.build_application(
        {
          position_id: params[:position_id], starting_date: params[:starting_date],
          closed_at: DateTime.now, accepted: true, locale: I18n.locale,
        }
      )
      ActiveRecord::Base.transaction do
        @resource.save!
        application.save!
      end

      if @resource.persisted? && application.persisted?
        render :show
      else
        raise "Could not create person's profile"
      end
    end

    def update
      if params[:position_id]
        @resource.application.position_id = params[:position_id] if params[:position_id]
      end
      if params[:starting_date]
        @resource.application.starting_date = params[:starting_date] if params[:starting_date]
      end

      @resource.application.save if @resource.application.changed?

      if permitted_params.to_h.any?
        @resource.assign_attributes(permitted_params)
      end
      unless @resource.save
        raise "Could not update person's information"
      end
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
