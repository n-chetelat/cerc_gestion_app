module Api
  class GoogleController < ApiController
    before_action :authorize_gmail, only: [:show]

    def show
      # ApplicationService.send_receipt_confirmation_email(Person.last, google_service)

      render json: {ok: "yes"}
    end

  end
end
