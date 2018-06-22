module StartingDates
  extend ActiveSupport::Concern

  SEMESTERS_MONTHS = {winter: 1, summer: 6, autumn: 9}

  included do

  end


  module ClassMethods

    def semester_to_s(date)
      date = Date.parse(date) if date.is_a?(String)
      season = SEMESTERS_MONTHS.invert[date.month]

      # Season may be nil when position in application is changed from semester-centerd to month-centered
      return month_to_s(date) if season.nil?

      season_name = "date.seasons.#{season}"
       "#{ActionController::Base.helpers.t(season_name)} #{date.year}"
    end

    def month_to_s(date)
      month_index = date.month
       "#{ActionController::Base.helpers.t("date.month_names")[month_index]} #{date.year}"
    end

    def generate_starting_dates(interval_type)
      choices = []
      current_year = Date.today.year
      case interval_type
      when :semester
        [current_year, current_year + 1].each do |year|
          SEMESTERS_MONTHS.each do |season, month|
            date = Date.parse("#{year}-#{month}-1")
            choices << { id: "#{date}", label: self.semester_to_s(date) }
          end
        end
      when :month
        current_month = Date.today.month
        date = Date.parse("#{current_year}-#{current_month}-1")
        12.times do
          choices << { id: date, label: self.month_to_s(date) }
          date = date.next_month
        end
      else
      end
      choices
    end

  end
end
