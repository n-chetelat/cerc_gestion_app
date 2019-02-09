class CorrespondenceController < ApplicationController
  before_action :authorize_gmail
  before_action :set_resource, only: [:fetch]

  def new
    token = Email::Token.find_by(name: "email-threads")
    if params[:token].present? && params[:token] == token.token
      token.destroy!
      email_service = ::EmailService.new(request)
      date = params[:date].try(:to_datetime) || DateTime.now
      email_service.fetch_threads_from_date(date)
      Rails.logger.info("Fetch of new correspondence successful.")
      head :ok
    else
      head :unauthorized
    end
  end

  private

    def set_resource
      @person ||= Person.find_by(uuid: params[:person_id])
    end

end
