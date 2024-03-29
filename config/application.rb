require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CercGestion
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths << "#{Rails.root}/*/concerns"
    config.autoload_paths << "#{Rails.root}/*/services"
    config.autoload_paths << "#{Rails.root}/lib/errors"

    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "localhost:5000", "127.0.0.1:5000",
            "cerc-recruitment.com", "www.cerc-recruitment.com",
            "staging-cerc-gestion.herokuapp.com"
        resource "*", headers: :any, methods: [:get, :post, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.channel assets: false
    end
  end
end
