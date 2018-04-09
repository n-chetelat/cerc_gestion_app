class PersonPhase < ApplicationRecord

  self.table_name = "persons_phases"

  before_save :update_person_email_labels

  validates :person_id, uniqueness: true

  belongs_to :phase
  belongs_to :person

  acts_as_list scope: :phase

  # def update_person_email_labels
  #   return if self.changes.include?("phase_id")
  #   old_phase = Phase.find(self.changed["phase_id"].first)
  #   self.person.swap_gmail_labels(old_phase.gmail_label, self.phase.gmail_label)
  # end

end
