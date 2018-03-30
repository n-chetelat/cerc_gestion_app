require 'google/apis/gmail_v1'

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'

require 'signet/oauth_2/client'
class GoogleService

  attr_reader :request
  attr_accessor :authorizer, :gmail_service

  APPLICATION_NAME = 'CERC Data Science'
  CLIENT_SECRETS_HASH = {"web" => {
    "client_id" => ENV["GOOGLE_API_CLIENT_ID"],
    "project_id" => ENV["GOOGLE_API_PROJECT_ID"],
    "auth_uri" => ENV["GOOGLE_API_AUTH_URI"],
    "token_uri" => ENV["GOOGLE_API_TOKEN_URI"],
    "auth_provider_x509_cert_url" => ENV["GOOGLE_API_AUTH_PROVIDER_X509_CERT_URL"],
    "client_secret" => ENV["GOOGLE_API_CLIENT_SECRET"],
    "redirect_uris" => ENV["GOOGLE_API_REDIRECT_URIS"].split(","),
    "javascript_origins" => ENV["GOOGLE_API_JAVASCRIPT_ORIGINS"].split(",")
  }}
  CREDENTIALS_PATH = File.join(Dir.home, ".credentials", "cerc-datasciencel.yaml")
  SCOPES = ['https://mail.google.com/']
  USER_ID = 'natalia.buitrago1@gmail.com'

  def initialize(request)
    @request = request

    client_id = Google::Auth::ClientId.from_hash(CLIENT_SECRETS_HASH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    @authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id, SCOPES, token_store, '/oauth2callback')


    @gmail_service = Google::Apis::GmailV1::GmailService.new
    @gmail_service.client_options.application_name = APPLICATION_NAME
    @gmail_service.authorization = credentials
  end

  def needs_authorization?
    # begin
    0/0
      gmail_service.get_user_profile(USER_ID)
      return false
    # rescue
    #   true
    # end
  end

  def authorization_uri
    authorizer.get_authorization_url(login_hint: USER_ID, request: request)
  end

  def get_emails
    gmail_service.list_user_messages(USER_ID, max_results: 50,  q: "didier")
  end

  def get_email
    gmail_service.get_user_message(USER_ID, '15bc6a5acd9b9dd2')
  end

  private

    def credentials
      authorizer.get_credentials(USER_ID, request)
    end


end
