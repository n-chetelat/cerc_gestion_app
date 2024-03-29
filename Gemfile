source 'https://rubygems.org'
ruby '2.7.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'rack-cors', require: 'rack/cors'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.2'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.16'
gem 'httparty'
gem 'rubyzip', '>= 1.0.0'

# Attachments
gem 'dragonfly', '~> 1.1.4'

# Cloud
gem 'dragonfly-google_data_store', '~> 1.0'

# UX helpers
gem 'jquery-rails'
gem 'select2-rails'
gem 'tinymce-rails'
gem 'jquery-minicolors-rails'

# ActiveRecord helpers
gem 'simple_enum'
gem 'acts_as_list'
gem 'acts_as_paranoid', github: 'ActsAsParanoid/acts_as_paranoid'
gem 'acts-as-taggable-on', '~> 4.0'

# Admin page
gem 'activeadmin'
gem 'devise'
gem "activeadmin-orderable"

# I18n
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'
gem 'activeadmin-globalize', '~> 1.0.0.pre'

# Gmail integration
gem 'omniauth-google-oauth2'
gem 'google-api-client', '~> 0.11'
gem 'mail'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'capistrano'
  # gem 'capistrano-rails'
  # gem 'capistrano3-puma'
  gem "letter_opener"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
