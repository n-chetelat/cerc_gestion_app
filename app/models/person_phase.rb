class PersonPhase < ApplicationRecord

  self.table_name = "persons_phases"

  validates :person_id, uniqueness: true

  belongs_to :phase
  belongs_to :person

  acts_as_list scope: :phase

  scope :not_deleted, -> { where(person_id: not_deleted_persons_ids) }

  protected


    def self.not_deleted_persons_ids
      Application.joins(:person).where(closed_at: nil)
        .select(:person_id)
    end
end
