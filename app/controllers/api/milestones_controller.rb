module Api
  class MilestonesController < ApiController

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
