module Positions
  class RecruitmentForm < ApplicationRecord

    self.table_name = "positions_recruitment_forms"

    belongs_to :position
    has_many :form_fields, class_name: "Positions::FormField", dependent: :destroy, foreign_key: "recruitment_form_id"

    accepts_nested_attributes_for :form_fields, allow_destroy: true

  end
end
