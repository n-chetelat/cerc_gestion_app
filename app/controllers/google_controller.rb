class GoogleController < ApplicationController
  before_action :authorize_gmail

  def authorize
    if !current_admin_user
      raise ActionController::Unauthorized
    end
  end

end
