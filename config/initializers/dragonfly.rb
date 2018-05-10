require 'dragonfly'
require 'dragonfly/google_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "c1a20e4a6efef921eef611bdc92719f83a6ddf333367e0873d17500822c48707"

  url_format "/media/:job/:name"

  keyfile_path = "tmp/google-cloud-credentials.json"
  keyfile = File.new(keyfile_path, "w+")
  keyfile << {
    "type": "service_account",
    "project_id" => ENV["GC_PROJECT_ID"] || Rails.application.secrets.google_cloud[:gc_project_id],
    "private_key_id" => ENV["GC_PRIVATE_KEY_ID"] || Rails.application.secrets.google_cloud[:gc_private_key_id],
    "private_key" => (ENV["GC_PRIVATE_KEY"] || Rails.application.secrets.google_cloud[:gc_private_key]).try(:gsub, "\\n", "\n"),
    "client_email" => ENV["GC_CLIENT_EMAIL"] || Rails.application.secrets.google_cloud[:gc_client_email],
    "client_id" => ENV["GC_CLIENT_ID"] || Rails.application.secrets.google_cloud[:gc_client_id],
    "auth_uri" => "https://accounts.google.com/o/oauth2/auth",
    "token_uri" => "https://accounts.google.com/o/oauth2/token",
    "auth_provider_x509_cert_url" => "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url" => ENV["GC_CLIENT_X509_CERT_URL"] || Rails.application.secrets.google_cloud[:gc_client_x509_cert_url]
  }.to_json

  keyfile.rewind

  datastore :google,
    bucket: ENV["GC_BUCKET_NAME"] || Rails.application.secrets.google_cloud[:gc_bucket_name],
    project: ENV["GC_PROJECT_ID"] || Rails.application.secrets.google_cloud[:gc_project_id],
    keyfile: keyfile_path

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
