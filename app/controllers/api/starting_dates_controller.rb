module Api
  class StartingDatesController < ApiController
    before_action :authenticate_admin_user!

    def semesters
      if params[:extended]
        options = set_extended_dates_options_for(:semester)
      end
      render json: ::DatesService.generate_starting_dates(:semester, options || {})
    end

    def months
      if params[:extended]
        options = set_extended_dates_options_for(:month)
      end
      render json: ::DatesService.generate_starting_dates(:month, options || {})
    end

    def timeline
      min_date = Person.active.joins(:application)
        .minimum("applications.starting_date")
      if min_date.nil? || min_date > Date.today
        min_date = Date.parse("#{Date.today.year}-01-01")
      end


      max_date = Person.active.joins(:application)
        .maximum("applications.ending_date").try(:to_date) || min_date + 24.months

      dates = ::DatesService.generate_semester_and_month_structure(
        min_date, max_date
      )
      render json: dates
    end

    private

      def set_extended_dates_options_for(interval_type)
        options = {}
        today = Date.today
        options[:min_date] = Date.parse("#{today.year}-01-01") - 3.year
        extra_years = 7

        case interval_type
        when :semester
          options[:years] = ::DatesService::DEFAULT_YEARS + extra_years
        when :month
          options[:months] = ::DatesService::DEFAULT_MONTHS + extra_years*12
        else
          raise "Invalid interval type"
        end
        options
      end

  end
end
