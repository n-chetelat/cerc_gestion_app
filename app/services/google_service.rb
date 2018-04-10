require 'google/apis/gmail_v1'

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'
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
    @token_store.load(USER_ID).nil?
  end

  def authorization_uri
    authorizer.get_authorization_url(login_hint: USER_ID, request: request)
  end

  def send_email_to(person, mail_object, options)

    message = Google::Apis::GmailV1::Message.new(
      raw: mail_object.to_s,
      thread_id: options[:thread_id]
    )
    gmail_service.send_user_message(USER_ID, message) do |result, error|
      if error
        raise "There was an error when sending a Gmail message."
      else
        request_object = Google::Apis::GmailV1::ModifyMessageRequest.new(
          add_label_ids: options[:label_ids]
        )
        gmail_service.modify_message(USER_ID, result.id, request_object) do |res, err|
          thread = Email::Thread.find_or_initialize_by(google_thread_id: result.thread_id)
          thread.messages.build(
            google_message_id: result.id,
            google_label_ids: result.label_ids,
            content: Base64.encode64(mail_object.to_s)
          )
          thread.persons_threads.build(person_id: person.id)
          thread.save!
        end


      end
    end
  end

  def create_email_label!(phase, name)
    label_object = Google::Apis::GmailV1::Label.new(name: name)
    gmail_service.create_user_label(USER_ID, label_object) do |result, error|
      if error
        nil
      else
        phase.email_label ||= phase.build_email_label
        phase.email_label.name = result.name
        phase.email_label.google_label_id = result.id
        phase.email_label.save!
        phase.email_label.reload
      end
    end
  end

  def update_email_label!(phase, new_name)
    label = phase.email_label
    label_object = Google::Apis::GmailV1::Label.new(id: label.google_label_id, name: new_name)
    gmail_service.update_user_label(USER_ID, label.google_label_id, label_object) do |result, error|
      if error
        nil
      else
        label.update_attributes(name: result.name, google_label_id: result.id)
      end
    end
  end

  def delete_email_label!(phase)
    label = phase.email_label
    return true unless label
    gmail_service.delete_user_label(USER_ID, label.google_label_id) do |result, error|
      if error
        nil
      else
        label.destroy
      end
    end
  end

  def update_thread_labels(thread, add_label_ids, remove_label_ids)
    request_object = Google::Apis::GmailV1::ModifyThreadRequest.new(
      add_label_ids: add_label_ids.compact, remove_label_ids: remove_label_ids.compact)
    gmail_service.modify_thread(USER_ID, thread.google_thread_id, request_object) do |result, error|
      if error
        raise "There was an error when updating Gmail thread labels."
      end
    end
  end

  private

    def credentials
      authorizer.get_credentials(USER_ID, request)
    end


end
