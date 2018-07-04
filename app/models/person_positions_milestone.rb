class PersonPositionsMilestone < ApplicationRecord

  self.table_name = "persons_positions_milestones"

  belongs_to :positions_milestone, class_name: "Positions::Milestone"
  belongs_to :person

  delegate :time_interval_ordinality, to: :positions_milestone

end
