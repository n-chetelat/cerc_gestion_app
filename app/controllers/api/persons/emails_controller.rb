module Api
  module Persons
    class EmailsController < ApiController
      before_action :authenticate_admin_user!, except: [:fetch]
      before_action :authorize_gmail
      before_action :set_resource

      def show
        render partial: "api/persons/email"
      end

      def fetch
        if params[:token] == Redis.current.get("email-fetch-#{@person.id}")
          email_service = ::EmailService.new(google_service)
          @person.threads.each do |thread|
            email_service.fetch_thread_messages(thread)
          end
          Redis.current.del("email-fetch-#{@person.id}")
          render partial: "api/persons/email"
        else
          render json: {error: "Unauthorized to take this action"}, status: 401
        end
      end

      def partial_path
      end

      def resource_name
        :email
      end

      private

        def set_resource
          @person ||= Person.find(params[:person_id])
        end

    end
  end
end
