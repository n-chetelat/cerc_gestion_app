module Api
  class PersonsPositionsMilestonesController < ApiController
    before_action :set_resource, only: [:show, :update, :destroy]

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


    def show
    end

    def create
      @resource = PersonPositionsMilestone.new(permitted_params)
      @resource.calculate_date_for_milestone! unless permitted_params[:date]
      if @resource.save
        render :show
      else
        raise "Person milestone could not be created: #{@resource.errors}"
      end
    end

    def update
      if params[:date].present?
        parsed_date = Date.parse(params[:date])
        new_date = Date.parse("#{parsed_date.year}-#{parsed_date.month}-01")
        @resource.date = new_date
      end
      if @resource.save
        render :show
      else
        raise "Person milestone could not be updated: #{@resource.errors}"
      end
    end

    def destroy
      @resource.destroy!
      render :show
    end

    private

      def set_resource
        @resource ||= PersonPositionsMilestone.find_by(id: params[:id])
      end

      def permitted_params
        params.permit(:person_id, :positions_milestone_id, :date)
      end

  end
end
