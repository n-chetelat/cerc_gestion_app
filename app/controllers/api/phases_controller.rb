module Api
  class PhasesController < ApiController

    def index
      @resources = Phase.all
    end

    def partial_path
      "api/phases/phase"
    end

    def resource_name
      :phase
    end

  end
end
