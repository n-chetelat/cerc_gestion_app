module Api
  class PersonsPositionsMilestonesController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/persons/positions_milestone"
      @resource_name = :person_milestone
    end

    def index
      active_milestone_ids = Person.active.joins(:persons_positions_milestones)
        .select("persons_positions_milestones.id")
      @resources = PersonPositionsMilestone.where(id: active_milestone_ids)
    end

  end
end
