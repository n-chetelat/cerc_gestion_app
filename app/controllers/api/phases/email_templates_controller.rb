module Api
  module Phases
    class EmailTemplatesController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_resource

      def show
        template = @phase.email_template
        if template
          @resource = template.compile_with_vars(@person)
        else
          render json: nil
        end
      end

      def partial_path
        "api/phases/email_templates/email_template"
      end

      def resource_name
        :email_template
      end

      private

        def set_resource
          @phase ||= Phase.find_by(uuid: params[:phase_id])
          @person ||= Person.find_by(uuid: params[:person_id])
        end

    end
  end
end
