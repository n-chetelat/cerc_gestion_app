module Api
  class StartingDatesController < ApiController
    before_action :authenticate_admin_user!

    def semesters
      options = set_options_for(:semester)
      render json: ::DatesService.generate_starting_dates(:semester, options)
    end

    def months
      options = set_options_for(:month)
      render json: ::DatesService.generate_starting_dates(:month, options)
    end

    def timeline
      min_date = Person.active.joins(:application)
        .minimum("applications.starting_date")
      if min_date.nil? || min_date < Date.today
        min_date = Date.parse("#{Date.today.year}-01-01")
      end

      max_date = Person.joins(:persons_positions_milestones)
        .maximum("persons_positions_milestones.date").try(:to_date) || min_date + 24.months
      dates = ::DatesService.generate_semester_and_month_structure(
        min_date, max_date
      )
      render json: dates
    end

    private

      def set_options_for(interval_type)
        return {} unless params[:min_date].present?

        options = {}
        options[:min_date] = Date.parse(params[:min_date])

        # If minimum date is in a past year,
        # add up the past years/months and the default
        # future years/months to calculate
        case interval_type
        when :semester
          years = (Date.today.year - options[:min_date].year)
          options[:years] = years + ::DatesService::DEFAULT_YEARS if years > 0
        when :month
          months = (Date.today.year*12+Date.today.month) - (options[:min_date].year*12+options[:min_date].month)
          options[:months] = months + ::DatesService::DEFAULT_MONTHS if months > 0
        else
          raise "Invalid interval type"
        end
        options
      end

  end
end
