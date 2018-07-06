module Api
  class StartingDatesController < ApiController
    before_action :authenticate_admin_user!

    def semesters
      render json: ProfileField.generate_starting_dates(:semester)
    end

    def months
      render json: ProfileField.generate_starting_dates(:month)
    end

    def timeline
      min_date = Person.active.joins(:application)
        .minimum("applications.starting_date")
      max_date = Person.joins(:persons_positions_milestones)
        .maximum("persons_positions_milestones.date").try(:to_date)
      render json: {min: min_date, max: max_date}
    end

  end
end
