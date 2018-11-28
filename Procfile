web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -t 25 -c 25
release: rake db:migrate
