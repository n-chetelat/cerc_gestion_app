module Api
  module Persons
    class EmailsController < ApiController
      before_action :authenticate_admin_user!
      before_action :authorize_gmail
      before_action :set_resource

      def show
      end

      def partial_path
        "api/persons/email"
      end

      def resource_name
        :person
      end

      private

        def set_resource
          @person ||= Person.find_by(uuid: params[:person_id])
        end

    end
  end
end
