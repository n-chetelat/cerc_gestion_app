desc "Call action for fetching new email"
task :fetch_recent_email_threads, [:days_ago] => :environment do |t, args|
  token = SecureRandom.base58(24)
  days = args[:days_ago] || 1
  date = days.to_i.days.ago
  Email::Token.create!(name: "email-threads", token: token)
  host = Rails.env.development? ? "http://localhost:5000" : "https://staging-cerc-gestion.herokuapp.com"
  ::HTTParty.get("#{host}/correspondence/new?token=#{token}&date=#{date}")
end
