module Api
  class PositionsController < ApiController

    def index
      @resources = Position.all
    end

    def partial_path
      "api/positions/position"
    end

    def resource_name
      :position
    end

  end
end
