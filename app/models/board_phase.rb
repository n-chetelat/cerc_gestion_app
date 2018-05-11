class BoardPhase < ApplicationRecord

  self.table_name = "boards_phases"

  belongs_to :board
  belongs_to :phase

  acts_as_list scope: :board

  scope :finals, -> { where(final: true) }
  scope :non_finals, -> { where(final: false) }
end
