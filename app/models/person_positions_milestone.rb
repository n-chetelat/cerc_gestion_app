class PersonPositionsMilestone < ApplicationRecord

  self.table_name = "persons_positions_milestones"

  belongs_to :positions_milestone, class_name: "Positions::Milestone", foreign_key: "positions_milestone_id"
  belongs_to :person

  delegate :time_interval_ordinality, to: :positions_milestone

  validate :milestone_belongs_to_person_position

  alias_method :milestone, :positions_milestone

  def calculate_date_for_milestone!
    return unless person.accepted?
    ordinality = self.time_interval_ordinality - 1
    time_interval = self.positions_milestone.time_interval
    starting_date = self.person.starting_date
    if time_interval == :semester
      semesters = ::DatesService::SEMESTERS_MONTHS.values
      index = semesters.find_index(starting_date.month)
      raise "invalid starting date for interval type" unless index
      # put starting date month number at beginning of array
      index.times { semesters.push(semesters.shift) }
      milestone_semester = semesters[(ordinality % semesters.size)]
      milestone_year = starting_date.year + ((ordinality + index) / semesters.size)
      milestone_date = Date.parse("#{milestone_year}-#{milestone_semester}-01")
    elsif time_interval == :month
      milestone_date = starting_date + ordinality.months
    else
      raise "invalid time interval for milestone"
    end
    self.date = milestone_date
  end

  private

    def milestone_belongs_to_person_position
      if self.person.position.id != self.positions_milestone.position_id
        errors.add(:position,
          "Milestone '#{self.positions_milestone.title}' cannot be assigned to person with Position '#{self.person.position.title}'.")
      end
    end
end
