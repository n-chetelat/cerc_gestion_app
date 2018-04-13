desc "Call action for fetching new email"
task :fetch_recent_email_threads => :environment do
  token = SecureRandom.base58(24)
  date = Email::Thread.order(updated_at: :asc).first.try(:updated_at).try(:to_datetime)
  date ||= DateTime.now
  Redis.current.set("email-threads", token)
  ::HTTParty.get("#{ENV["RAILS_HOST"]}/correspondence/new?token=#{token}&date=#{date}")
end
