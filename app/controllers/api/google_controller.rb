module Api
  class GoogleController < ApiController
    before_action :authorize_gmail, only: [:show]

    def show
      @result = service.get_emails
      @mail = service.get_email

      render json: {mail: @mail, result: @result}
    end

    private

      def authorize_gmail
        if service.needs_authorization?
          redirect_to service.authorization_uri
        end
      end

      def service
        if @service && @service.needs_authorization?
          @service = ::GoogleService.new(request)
          return @service
        end
        @service = ::GoogleService.new(request)
      end


  end
end
