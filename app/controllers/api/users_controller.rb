module Api
  class UsersController < ApiController
    before_action :authenticate_admin_user!

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/users/user"
      @resource_name = :user
    end

    def show
      @resource = current_admin_user
    end
  end
end
