module Api
  module Phases
    class EmailTemplatesController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_resource

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/phases/email_templates/email_template"
        @resource_name = :email_template
      end

      def show
        template = @phase.email_template
        if template
          @resource = template.compile_with_vars(@person)
        else
          render json: nil
        end
      end

      private

        def set_resource
          @phase ||= Phase.find_by(uuid: params[:phase_id])
          @person ||= Person.find_by(uuid: params[:person_id])
        end

    end
  end
end
