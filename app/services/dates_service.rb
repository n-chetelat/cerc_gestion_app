class DatesService

  SEMESTERS_MONTHS = {winter: 1, summer: 6, autumn: 9}
  MONTHS_IN_SEMESTER = {
    winter: [1,2,3,4,5],
    summer: [6,7,8],
    autumn: [9,10,11,12]
  }

  def self.get_semesters_in_interval(min_date, max_date)
    raise "Invalid date interval" if min_date > max_date
    min_year = min_date.year
    year_count = max_date.year - min_year
    year_count = 1 if year_count < 1
    dates = []

    year_count.times do |i|
      year = min_year + i
      SEMESTERS_MONTHS.each do |season, month|
        date = Date.parse("#{year}-#{month}-1")
        dates << { id: "#{date}", label: self.semester_to_s(date) }
      end
    end
    dates
  end

  def self.get_months_in_interval(min_date, max_date)
    raise "Invalid date interval" if min_date > max_date
    month_count = (max_date.year*12+max_date.month) - (min_date.year*12+min_date.month)
    month_count += 1 # accounts for the entirety of the months included, not just the interval between the dates
    dates = []
    date = min_date

    month_count.times do
      dates << { id: date.to_s, label: self.month_to_s(date) }
      date = date.next_month
    end
    dates
  end

  def self.semester_to_s(date)
    date = Date.parse(date) if date.is_a?(String)
    season = SEMESTERS_MONTHS.invert[date.month]

    # Season may be nil when position in application is changed from semester-centerd to month-centered
    return month_to_s(date) if season.nil?

    season_name = "date.seasons.#{season}"
     "#{ActionController::Base.helpers.t(season_name)} #{date.year}"
  end

  def self.month_to_s(date)
    date = Date.parse(date) if date.is_a?(String)
    month_index = date.month
     "#{ActionController::Base.helpers.t("date.month_names")[month_index]} #{date.year}"
  end

  def self.generate_starting_dates(interval_type, options={})
    months = options[:months] || 12
    years = options[:years] || 2
    choices = []
    min_date = Date.parse("#{Date.today.year}-#{Date.today.month}-01")

    case interval_type
    when :semester
      choices = self.get_semesters_in_interval(min_date, (min_date + years.years))
    when :month
      choices = self.get_months_in_interval(min_date, (min_date + months.months))
    else
      raise "Invalid interval type #{interval_type}"
    end
    choices
  end

  def self.generate_semester_and_month_structure(min_date, max_date)
    semesters = self.get_semesters_in_interval(min_date, max_date)
    semesters_by_month = SEMESTERS_MONTHS.invert

    semesters.each do |semester|
      min_month = Date.parse(semester[:id])
      season = semesters_by_month[min_month.month]
      raise "Invalid semester" if season.nil?
      months = MONTHS_IN_SEMESTER[season]
      max_month = Date.parse("#{min_month.year}-#{months.last}-01")
      semester[:months] = self.get_months_in_interval(min_month, max_month)
    end

    semesters
  end
end
