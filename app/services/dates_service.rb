class DatesService

  SEMESTERS_MONTHS = {winter: 1, summer: 6, autumn: 9}
  MONTHS_IN_SEMESTER = {
    winter: [1,2,3,4,5],
    summer: [6,7,8],
    autumn: [9,10,11,12]
  }
  DEFAULT_MONTHS = 12
  DEFAULT_YEARS = 2

  def self.current_semester(date)
    month = Date.parse("#{date.year}-#{date.month}-01").to_s #Date object guaranteed well-formed date string with zero-padding
    self.month_date_to_semester_date(month)
  end

  def self.current_month(date)
    Date.parse("#{date.year}-#{date.month}-01")
  end

  def self.end_of_semester_date(date)
    month = self.get_months_in_semester(date)[-1]
    Date.parse("#{date.year}-#{month}-01").end_of_month
  end

  def self.end_of_month_date(date)
    self.current_month(date).end_of_month
  end

  def self.get_semesters_in_interval(min_date, max_date)
    raise "Invalid date interval" if min_date > max_date
    min_year = min_date.year
    year_count = max_date.year - min_year + 1
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

  def self.get_months_in_semester(date)
    MONTHS_IN_SEMESTER[SEMESTERS_MONTHS.invert[date.month]]
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

  def self.semester_label_to_date(label)
    label.strip!
    semester, month = SEMESTERS_MONTHS.find do |s, m|
      label.downcase.scan(/(?:\s*)((?:.*)#{s}(?:.*))(?:\s*)/).any?
    end
    year = label.downcase.scan(/\d{4}/).first

    if month && year
      new_date = "#{year}-#{month}-01"
      Date.parse(new_date)
    else
      nil
    end
  end

  def self.month_date_to_semester_date(date_string)
    date = Date.parse(date_string)
    return date if SEMESTERS_MONTHS.values.include?(date.month)

    matches_by_semester = {}.tap do |h|
      self.semester_regexes.each do |semester, regex|
        if match = regex.match(date_string)
          h[semester] = match
        end
      end
    end

    unless matches_by_semester.keys.size == 1
      raise "Month date #{date_string} cannot be converted to semester"
    end

    semester_month = SEMESTERS_MONTHS[matches_by_semester.keys.first].to_s.rjust(2, '0')
    Date.parse("#{date.year}-#{semester_month}-01")
  end

  def self.generate_starting_dates(interval_type, options={})
    months = options[:months] || DEFAULT_MONTHS
    years = options[:years] || DEFAULT_YEARS
    choices = []
    min_date = options[:min_date] || Date.parse("#{Date.today.year}-#{Date.today.month}-01")

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

    semesters.each do |semester|
      min_month = Date.parse(semester[:id])
      months = self.get_months_in_semester(min_month)
      raise "Invalid semester" if months.nil?
      max_month = Date.parse("#{min_month.year}-#{months.last}-01")
      semester[:months] = self.get_months_in_interval(min_month, max_month)
    end

    semesters
  end

  # Qty includes current semester, so qty == 1 gives only current.
  def self.find_date_x_semesters_away(date, qty)
    qty = 1 if (qty <= 0)
    qty = qty - 1
    semesters = SEMESTERS_MONTHS.values
    index = semesters.find_index(date.month)
    raise "invalid date" unless index
    # put starting date month number at beginning of array
    index.times { semesters.push(semesters.shift) }
    semester = semesters[(qty % semesters.size)]
    year = date.year + ((qty + index) / semesters.size)
    Date.parse("#{year}-#{semester}-01")
  end

  private

    def self.semester_regexes
      @@semester_regexes ||= begin
        {}.tap do |regexes|
          MONTHS_IN_SEMESTER.each do |semester, months|
            options = months.map{|m| m.to_s.rjust(2, "0") }.join("|")
            regexes[semester] = /\d{4}-(#{options})-\d{2}/
          end
        end
      end
    end
end
