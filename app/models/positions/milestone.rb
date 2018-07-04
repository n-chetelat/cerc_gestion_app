module Positions
  class Milestone < ApplicationRecord

    self.table_name = "positions_milestones"

    belongs_to :position

    has_many :persons_positions_milestones, class_name: "::PersonPositionsMilestone", dependent: :destroy

    validates :title, :time_interval_ordinality, presence: true

    acts_as_list column: :time_interval_ordinality, scope: :position
  end
end
