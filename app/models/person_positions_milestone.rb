class PersonPositionsMilestone < ApplicationRecord

  self.table_name = "persons_positions_milestones"

  belongs_to :positions_milestone, class_name: "Positions::Milestone", foreign_key: "positions_milestone_id"
  belongs_to :person

  delegate :time_interval_ordinality, to: :positions_milestone

  validates :date, presence: true
  validate :milestone_belongs_to_person_position
  validate :person_is_accepted
  validates :positions_milestone_id, uniqueness: { scope: :person_id }
  validate :match_application_dates_with_milestones

  alias_method :milestone, :positions_milestone

  def calculate_date_for_milestone!
    return unless person.accepted?
    ordinality = self.time_interval_ordinality
    time_interval = self.positions_milestone.time_interval
    starting_date = self.person.starting_date
    if time_interval == :semester
      milestone_date = ::DatesService.find_date_x_semesters_away(starting_date, ordinality)
    elsif time_interval == :month
      milestone_date = starting_date + (ordinality - 1).months
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

    def person_is_accepted
      person = Person.find_by(id: self.person_id)
      unless person.try(:accepted?)
        errors.add(:person_id, "The person with id #{self.person_id} does not have an accepted profile.")
      end
    end

    def match_application_dates_with_milestones
      unless self.date >= self.person.starting_date
        errors.add(:invalid_date, "Milestone dates cannot come before starting date")
        return
      end

      return if self.person.ending_date.nil?
      unless self.date <= self.person.ending_date
        errors.add(:invalid_date, "Milestone dates cannot exceed ending date")
      end
    end
end
