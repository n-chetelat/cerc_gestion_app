module Api
  class GoogleController < ApiController
    before_action :authorize_gmail, only: [:show]

    def show
      # service.send_email_to(Person.last, EmailTemplate.find(1))

      head :ok
    end

    private

      def authorize_gmail
        if service.needs_authorization?
          redirect_to service.authorization_uri
        end
      end

      def service
        @service ||= ::GoogleService.new(request)
      end


  end
end
