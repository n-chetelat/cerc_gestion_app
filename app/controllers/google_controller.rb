class GoogleController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :authorize_gmail

  def authorize
  end

end
