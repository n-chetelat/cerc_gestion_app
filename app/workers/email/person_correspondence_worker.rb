class Email::PersonCorrespondenceWorker
  include Sidekiq::Worker

  def perform(person_id)
    # This needs to be an http request because
    # Gmail OAuth requires a request object.
    token = Redis.current.get("email-fetch-#{person_id}")
    ::HTTParty.get("#{ENV["RAILS_HOST"]}/correspondence/#{person_id}/fetch?token=#{token}")
  end
end
