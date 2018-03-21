module Semesters
  extend ActiveSupport::Concern

  included do

    WINTER_DEADLINE_MONTH = 9
    AUTUMN_DEADLINE_MONTH = 2
    START_WINTER = "january 1"
    START_AUTUMN = "july 1"

  end

  module ClassMethods
    def generate_next_admission_dates(count = 3)
      current_month = Date.today.month
      if current_month.between?(AUTUMN_DEADLINE_MONTH, WINTER_DEADLINE_MONTH - 1)
        first_admission_date = Date.parse(START_AUTUMN)
      else
        first_admission_date = Date.parse(START_WINTER)
      end
      semesters = [first_admission_date]
      (count - 1).times do |i|
        semesters << semesters[-1] + 6.months
      end
      semesters.map do |semester|
        {id: semester.to_s, label: self.semester_to_s(semester)}
      end
    end

    def semester_to_s(semester_date)
      month = semester_date.month
      if month.between?(Date.parse(START_WINTER).month, Date.parse(START_AUTUMN).month - 1)
        "#{ActionController::Base.helpers.t("date.seasons.winter")} #{semester_date.year}"
      else
        "#{ActionController::Base.helpers.t("date.seasons.autumn")} #{semester_date.year}"
      end
    end
  end
end
