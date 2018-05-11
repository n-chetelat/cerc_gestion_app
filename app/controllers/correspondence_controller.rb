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
      head :ok
    else
      render json: {error: "Unauthorized to take this action"}, status: 401
    end
  end

  def fetch
    token = Email::Token.find_by(name: "email-fetch-#{@person.uuid}")
    if params[:token].present? && params[:token] == token.token
      token.destroy!
      email_service = ::EmailService.new(request)
      @person.threads.each do |thread|
        next unless email_service.thread_exists_in_inbox?(thread.google_thread_id)
        email_service.fetch_thread_message_details(thread)
      end
      head :ok
    else
      render json: {error: "Unauthorized to take this action"}, status: 401
    end
  end

  private

    def set_resource
      @person ||= Person.find_by(uuid: params[:person_id])
    end

end
