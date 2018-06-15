class BoardPhase < ApplicationRecord

  self.table_name = "boards_phases"

  belongs_to :board
  belongs_to :phase

  acts_as_list scope: :board

  validate :only_accepting_when_final

  scope :finals, -> { where(final: true) }
  scope :non_finals, -> { where(final: false) }

  protected

    def only_accepting_when_final
      if !self.final && self.accepting
        errors.add(:accepting, "An accepting Tag must be final")
      end
    end

end
