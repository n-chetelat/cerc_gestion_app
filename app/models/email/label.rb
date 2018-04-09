module Email
  class Label < ApplicationRecord

    self.table_name = "email_labels"

    belongs_to :phase, class_name: "Phase", foreign_key: "phase_id", inverse_of: :email_label

  end
end
