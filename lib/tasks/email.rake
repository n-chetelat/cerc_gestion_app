desc "Call action for fetching new email"
task :fetch_recent_email_threads, [:days_ago] => :environment do |t, args|
  # HACK - limit the times the action will be performed to remedy inflexible Heroku Scheduler intervals.
  # https://elements.heroku.com/addons/scheduler
  now = DateTime.now
  during_day = now.hour.between?(5, 19) # Make calls only during the day
  twenty_minutes = [2, 3, 22, 23, 42, 43].include?(now.minute) # Make calls every 20 minutes, with a one minute allowance.


  if during_day && twenty_minutes
    days = args[:days_ago] || 1
    date = days.to_i.days.ago
    token = SecureRandom.base58(24)
    Email::Token.create!(name: "email-threads", token: token)
    host = Rails.env.development? ? "http://localhost:5000" : "https://staging-cerc-gestion.herokuapp.com"
    puts "Performing email thread refresh..."
    ::HTTParty.get("#{host}/correspondence/new?token=#{token}&date=#{date}")
  else
    puts "Skipping email threads refresh."
  end
end
