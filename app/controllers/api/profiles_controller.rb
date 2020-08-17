module Api
  class ProfilesController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show, :update, :destroy, :finished, :canceled]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/profiles/profile"
      @resource_name = :person
    end

    def index
      respond_to do |format|
        format.json {
          offset = params[:offset].to_i || 0
          resources_to_load = 50
          # order should be active + incoming + finished + rejected + canceled
          @resources = Person.post_recruitment
            .post_recruitment_ordered.offset(offset).limit(resources_to_load)
        }
        format.csv {
          service = ::ProfileCsvService.new(params[:profile_ids], params[:field_ids])
          data = service.generate_csv_file_structure
          @headers = data[:headers]
          @lines = data[:lines]
          headers["Content-Disposition"] = "attachment; filename=\"cerc_profiles_#{DateTime.now.to_s}\""
          headers["Content-Type"] ||= "text/csv"
        }
      end

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
        service = ::ApplicationClosingService.new(application)
        service.create_default_end_date
        service.create_person_position_milestones
      end

      if @resource.persisted? && application.persisted?
        render :show
      else
        raise "Could not create person's profile"
      end
    end

    def update
      if params[:position_id]
        @resource.application.position_id = params[:position_id]
      end
      if params[:starting_date]
        @resource.application.starting_date = params[:starting_date]
      end
      if params[:ending_date]
        @resource.application.ending_date = params[:ending_date]
      end

      @resource.application.save if @resource.application.changed?

      if permitted_params.to_h.any?
        @resource.assign_attributes(permitted_params)
      end
      unless @resource.save
        raise "Could not update person's information"
      else
        if params[:position_id]
          @resource.persons_positions_milestones.destroy_all
          service = ::ApplicationClosingService.new(@resource.application)
          service.create_default_end_date
          service.create_person_position_milestones
        end
        render :show
      end

    end

    def finished
      @resource.finished_at = DateTime.now
      application = @resource.application
      application.ending_date = DatesService.send("current_#{application.time_interval}", DateTime.now)
      application.save!
      unless @resource.save
        raise "Could not mark profile as finished"
      end
      render :show
    end

    def canceled
        @resource.transaction do
          @resource.canceled_at = DateTime.now
          @resource.persons_positions_milestones.destroy_all
          application = @resource.application
          application.ending_date = DatesService.send("current_#{application.time_interval}", DateTime.now)
          application.save!
        end
      unless @resource.save
        raise "Could not mark profile as canceled"
      end
      render :show
    end

    private

      def set_resource
        @resource = Person.find_by(uuid: params[:id])
      end

      def permitted_params
        params.permit(:name, :lastname, :email)
      end

  end
end
