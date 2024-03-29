module Positions
  class Milestone < ApplicationRecord

    self.table_name = "positions_milestones"

    belongs_to :position

    has_many :persons_positions_milestones, class_name: "::PersonPositionsMilestone", foreign_key: "positions_milestone_id", dependent: :destroy

    validates :title, :time_interval_ordinality, presence: true
    validates :time_interval_ordinality, numericality: { greater_than: 0 }

    acts_as_list column: :time_interval_ordinality, scope: :position

    delegate :time_interval, to: :position

    default_scope { order(time_interval_ordinality: :asc) }
  end
end
