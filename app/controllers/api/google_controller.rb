module Api
  class GoogleController < ApiController
    before_action :authorize_gmail, only: [:show]

    def show
      # ApplicationService.send_receipt_confirmation_email(Person.last, request)

      render json: {ok: "yes"}
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
