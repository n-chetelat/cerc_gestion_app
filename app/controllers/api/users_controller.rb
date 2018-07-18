module Api
  class UsersController < ApiController
    before_action :authenticate_admin_user!, only: [:show]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/users/user"
      @resource_name = :user
    end

    def show
      @resource = current_admin_user
    end

    def auth
      render json: { authorized: current_admin_user.present? }
    end
  end
end
