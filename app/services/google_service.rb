require 'google/apis/gmail_v1'

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/redis_token_store'
require 'redis'

require 'signet/oauth_2/client'
class GoogleService

  attr_reader :request
  attr_accessor :authorizer, :gmail_service

  APPLICATION_NAME = 'RecruitmentStaging'
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
  SCOPES = ['https://mail.google.com/']
  USER_ID = ENV['GMAIL_ADDRESS']

  def initialize(request)
    @request = request

    client_id = Google::Auth::ClientId.from_hash(CLIENT_SECRETS_HASH)

    @token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)

    @authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id, SCOPES, @token_store, '/oauth2callback')


    @gmail_service = Google::Apis::GmailV1::GmailService.new
    @gmail_service.client_options.application_name = APPLICATION_NAME
    @gmail_service.authorization = credentials
  end

  def needs_authorization?
    begin
      @gmail_service.get_user_profile(USER_ID)
      @token_store.load(USER_ID).nil?
    rescue Google::Apis::AuthorizationError
      @token_store.delete(USER_ID)
      true
    end

  end

  def authorization_uri
    authorizer.get_authorization_url(login_hint: USER_ID, request: request)
  end

  private

    def credentials
      authorizer.get_credentials(USER_ID, request)
    end


end
