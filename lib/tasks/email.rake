desc "Call action for fetching new email at specific interval"
task :fetch_recent_email_threads, [:days_ago] => :environment do |t, args|
  # HACK - limit the times the action will be performed to remedy inflexible Heroku Scheduler intervals.
  # https://elements.heroku.com/addons/scheduler
  now = DateTime.now
  during_day = now.hour.between?(5, 19) # Make calls only during the day
  (0..5).to_a.include?(now.minute % 20)
  twenty_minutes = (0..5).to_a.include?(now.minute % 20) # Make calls every 20 minutes, with a 5-minute allowance for cron to boot.


  if during_day && twenty_minutes
    fetch_email(args[:days_ago])
  else
    puts "Skipping email threads refresh."
  end
end

desc "Call action for fetching email at any time"
task :fetch_email_threads, [:days_ago] => :environment do |t, args|
  fetch_email(args[:days_ago])
end

def fetch_email(days_ago = 1)
  days = days_ago
  date = days.to_i.days.ago
  token = SecureRandom.base58(24)
  Email::Token.create!(name: "email-threads", token: token)
  host = Rails.env.development? ? "http://localhost:5000" : ENV["RAILS_HOST"]
  puts "Performing email thread refresh..."
  ::HTTParty.get("#{host}/correspondence/new?token=#{token}&date=#{date}")
end
