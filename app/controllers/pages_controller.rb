class PagesController < ApplicationController
  skip_before_action :set_locale

  def home
    render :home
  end

end
