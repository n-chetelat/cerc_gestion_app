module Api
  module Persons
    class EmailsController < ApiController
      before_action :authenticate_admin_user!
      before_action :authorize_gmail
      before_action :set_resource

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/persons/email"
        @resource_name = :person
      end

      def show
      end

      private

        def set_resource
          @person ||= Person.find_by(uuid: params[:person_id])
        end

    end
  end
end
