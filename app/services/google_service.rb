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
  CREDENTIALS_PATH = File.join(Dir.home, ".credentials", "cerc-datascience.yaml")
  SCOPES = ['https://mail.google.com/']
  USER_ID = 'natalia.buitrago1@gmail.com'

  def initialize(request)
    @request = request

    client_id = Google::Auth::ClientId.from_hash(CLIENT_SECRETS_HASH)

    @token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)

    @authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id, SCOPES, @token_store, '/oauth2callback')


    @gmail_service = Google::Apis::GmailV1::GmailService.new
    @gmail_service.client_options.application_name = APPLICATION_NAME
    @gmail_service.authorization = credentials
  end

  def needs_authorization?
    @token_store.load(USER_ID).nil?
  end

  def authorization_uri
    authorizer.get_authorization_url(login_hint: USER_ID, request: request)
  end

  def send_email_to(person, email_template)
    if needs_authorization?
      raise "Authorization needed"
    end

    compiled_email = email_template.compile_with_vars(person)

    mail = Mail.new do
      to person.email
      subject compiled_email.subject
    end
    text_part = Mail::Part.new do
      body compiled_email.plain
    end
    html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body compiled_email.body
    end
    mail.text_part = text_part
    mail.html_part = html_part

    message = Google::Apis::GmailV1::Message.new(raw: mail.to_s)
    draft = Google::Apis::GmailV1::Draft.new(message: message)
    gmail_service.create_user_draft(USER_ID, draft) do |result, error|
      unless error
        gmail_service.send_user_draft(USER_ID, result)
      end
    end
  end


  private

    def credentials
      authorizer.get_credentials(USER_ID, request)
    end


end
