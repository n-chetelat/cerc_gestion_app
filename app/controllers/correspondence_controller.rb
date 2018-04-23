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
    if params[:token].present? && params[:token] == Redis.current.get("email-fetch-#{@person.uuid}")
      email_service = ::EmailService.new(request)
      @person.threads.each do |thread|
        email_service.fetch_thread_message_details(thread)
        thread.save # trigger before_save callbacks
      end
      Redis.current.del("email-fetch-#{@person.uuid}")
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
