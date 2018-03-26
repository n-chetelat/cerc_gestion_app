class ApiController < ApplicationController

  prepend_view_path Rails.root.join('app/views')

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale].try(:to_sym) || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

end
