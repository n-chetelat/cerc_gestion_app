class PagesController < ApplicationController
  skip_before_action :set_locale

  def home
    if current_admin_user
      render :admin
    else
      render :home
    end
  end

  def admin
  end

end
