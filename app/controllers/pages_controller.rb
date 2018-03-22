class PagesController < ApplicationController

  def home
    if current_admin_user
      render :admin
    else
      render :home
    end
  end

  def upload
    0/0
  end

  def admin
  end

end
