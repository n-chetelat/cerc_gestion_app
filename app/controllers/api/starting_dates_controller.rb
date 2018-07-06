module Api
  class StartingDatesController < ApiController
    before_action :authenticate_admin_user!

    def semesters
      render json: ::DatesService.generate_starting_dates(:semester)
    end

    def months
      render json: ::DatesService.generate_starting_dates(:month)
    end

    def timeline
      min_date = Person.active.joins(:application)
        .minimum("applications.starting_date")
      max_date = Person.joins(:persons_positions_milestones)
        .maximum("persons_positions_milestones.date").try(:to_date)
      dates = ::DatesService.generate_semester_and_month_structure(
        min_date, max_date
      )
      render json: dates
    end

  end
end
