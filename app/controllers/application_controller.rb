class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :set_locale

  rescue_from ::GmailOauthError do |error|
    ::GmailOauthMailer.authorization_needed.deliver_now
    render json: {error: "#{error.msg}"}, status: 500
  end

  def set_locale
    I18n.locale = params[:locale].try(:to_sym) || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def google_service
    @google_service ||= ::GoogleService.new(request)
  end

  def authorize_gmail
    if google_service.needs_authorization?
      if current_admin_user
        redirect_to google_service.authorization_uri
      else
        raise ::GmailOauthError
      end
    end
  end

end
