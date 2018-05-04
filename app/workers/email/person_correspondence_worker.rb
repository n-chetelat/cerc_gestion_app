class Email::PersonCorrespondenceWorker
  include Sidekiq::Worker

  def perform(person_id)
    # This needs to be an http request because
    # Gmail OAuth requires a request object.
    token = Email::Token.find_by(name: "email-fetch-#{person_id}").try(:token)
    ::HTTParty.get("#{ENV["RAILS_HOST"]}/correspondence/#{person_id}/fetch?token=#{token}")
  end
end
