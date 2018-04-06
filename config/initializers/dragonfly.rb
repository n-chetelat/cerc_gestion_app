require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "c1a20e4a6efef921eef611bdc92719f83a6ddf333367e0873d17500822c48707"

  url_format "/media/:job/:name"

  datastore :s3,
    bucket_name: ENV["S3_BUCKET_NAME"] || Rails.application.secrets.aws[:s3_bucket_name],
    access_key_id: ENV["S3_KEY"] || Rails.application.secrets.aws[:s3_key],
    secret_access_key: ENV["S3_SECRET"] || Rails.application.secrets.aws[:s3_secret],
    region: "us-east-2"

  # datastore :file,
  #   root_path: Rails.root.join('public/system/dragonfly', Rails.env),
  #   server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveSupport.on_load(:active_record) do
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
end
