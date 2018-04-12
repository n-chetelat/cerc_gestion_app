class EmailWorker
  include Sidekiq::Worker

  def perform(person_id)
    # This needs to be an http request because
    # Gmail OAuth requires a request object.
    token = Redis.current.get("email-fetch-#{person_id}")
    ::HTTParty.get("#{ENV["RAILS_HOST"]}/api/persons/#{person_id}/email/fetch?token=#{token}")
  end
end
