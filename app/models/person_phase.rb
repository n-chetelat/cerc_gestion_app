class PersonPhase < ApplicationRecord

  self.table_name = "persons_phases"

  validates :person_id, uniqueness: true

  belongs_to :phase
  belongs_to :person

  acts_as_list scope: :phase

end
