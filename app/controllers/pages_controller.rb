class PagesController < ApplicationController
  skip_before_action :set_locale

  def home
    ser = ApplicationClosingService.new(Application.last)
    ser.store_application_fields_in_profile_fields
    if current_admin_user
      render :admin
    else
      render :home
    end
  end

  def admin
  end

end
