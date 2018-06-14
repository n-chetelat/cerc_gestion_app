module Api
  class ApplicationsController < ApiController
    before_action :authenticate_admin_user!, only: [:index, :show, :update, :deletion]
    before_action :authorize_gmail, only: [:create]
    before_action :set_resource, only: [:show, :update, :deletion]

    after_action :broadcast_changes, only: [:create, :update, :destroy]
    after_action :email_application_materials, only: [:create]

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

        PhaseService.place_person_in_phase(@resource.person, Phase.current_initial, request)
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

    # Mark application for deletion in rake task
    def deletion
      @resource.closed_at = DateTime.now
      if @resource.save
        render :show
      end
    end

    private

      def set_resource
        @resource = Application.find(params[:id])
      end

      def broadcast_changes
        if @resource
          slugs = @resource.person.current_phase.boards.pluck(:slug)
          BoardChannelService.send_phases_update(slugs)
        end
      end

      def email_application_materials
        ApplicationService.email_application_materials(@resource, request) if @resource
      end

  end
end
