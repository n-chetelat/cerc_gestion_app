module Api
  class ApplicationsController < ApiController
    before_action :authenticate_admin_user!, only: [:index, :show, :update, :close]
    before_action :authorize_gmail, only: [:create]
    before_action :set_resource, only: [:show, :update, :close]

    after_action :broadcast_changes, only: [:create, :update, :destroy]
    after_action :email_application_materials, only: [:create]
    after_action :set_up_closed_application_profile, only: [:close]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/applications/application"
      @resource_name = :application
    end

    def index
      @resources = Application.all
    end

    def show
      @form_fields = ::ApplicationService.fields_to_hash_for(@resource)
    end

    def create
      if @resource = ApplicationService.create_application(params)
        email_labels = PhaseService.prepare_email_label_lists(@resource.person, Phase.current_initial)

        PhaseService.place_person_in_phase(@resource.person, Phase.current_initial)
        PhaseService.apply_automatic_callbacks_for(@resource.person, Phase.current_initial, request)
        PhaseService.update_email_labels_for(@resource.person, email_labels[:add_label_ids],
          email_labels[:remove_label_ids], request)
        BoardChannelService.send_new_application_message
        head :ok
      end
    end

    def update
      if @resource = ApplicationService.update_application(@resource, params)
        render :show
      end
    end

    # Mark application for cleanup of materials (files and emails only) in rake task
    # Application is not destroyed
    def close
      @resource.closed_at = DateTime.now
      @resource.accepted = true if params[:accepted]
      if @resource.save
        render :show
      end
    end

    private

      def set_resource
        @resource = Application.find(params[:id])
      end

      def broadcast_changes
        if @resource && @resource.closed_at.nil?
          slugs = @resource.person.current_phase.boards.pluck(:slug)
          BoardChannelService.send_phases_update(slugs)
        end
      end

      def email_application_materials
        ApplicationService.email_application_materials(@resource, request) if @resource
      end

      def set_up_closed_application_profile
        service = ::ApplicationClosingService.new(@resource)
        service.store_application_fields_in_profile_fields
        service.create_default_end_date
        service.create_person_position_milestones if @resource.accepted
      end

  end
end
