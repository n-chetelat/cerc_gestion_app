class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join('frontend')

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale].try(:to_sym) || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
