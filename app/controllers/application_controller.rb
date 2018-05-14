require 'google/apis/gmail_v1'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :set_locale

  rescue_from ::Google::Apis::ClientError, ::Google::Apis::ServerError do |error|
    render json: {error: "#{error.status_code} Error with Google Api: #{error}"}, status: error.status_code
  end
  rescue_from ::GmailOauthError, ::Google::Apis::AuthorizationError do |error|
    # ::GmailOauthMailer.authorization_needed.deliver_now # Uncomment if app configured to send email.
    head :internal_server_error
  end

  def set_locale
    I18n.locale = params[:locale].try(:to_sym) || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def authorize_gmail
    google_service = ::GoogleService.new(request)
    if google_service.needs_authorization?
      if current_admin_user
        redirect_to google_service.authorization_uri
      else
        raise ::GmailOauthError
      end
    end
  end

end
