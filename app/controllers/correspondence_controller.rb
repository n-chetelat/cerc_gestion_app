class CorrespondenceController < ApplicationController
  before_action :authorize_gmail
  before_action :set_resource, only: [:fetch]

  def new
    if params[:token].present? && params[:token] == Redis.current.get("email-threads")
      email_service = ::EmailService.new(request)
      date = params[:date].try(:to_datetime) || DateTime.now
      email_service.fetch_threads_from_date(date)
      Redis.current.del("email-threads")
      head :ok
    else
      render json: {error: "Unauthorized to take this action"}, status: 401
    end
  end

  def fetch
    if params[:token].present? && params[:token] == Redis.current.get("email-fetch-#{@person.id}")
      email_service = ::EmailService.new(request)
      @person.threads.each do |thread|
        email_service.fetch_thread_message_details(thread)
      end
      Redis.current.del("email-fetch-#{@person.id}")
      head :ok
    else
      render json: {error: "Unauthorized to take this action"}, status: 401
    end
  end

  private

    def set_resource
      @person ||= Person.find(params[:person_id])
    end

end
