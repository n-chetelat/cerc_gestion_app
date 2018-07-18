module Api
  class MilestonesController < ApiController
    before_action :authenticate_admin_user!
    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/milestones/milestone"
      @resource_name = :milestone
    end

    def index
      @resources = Positions::Milestone.all
    end

  end
end
