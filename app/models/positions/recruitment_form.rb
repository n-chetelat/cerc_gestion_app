module Positions
  class RecruitmentForm < ApplicationRecord
    include Semesters

    self.table_name = "positions_recruitment_forms"

    attr_accessor :name, :lastname, :email, :starting_semester

    belongs_to :position
    has_many :form_fields, class_name: "Positions::FormField", dependent: :destroy, foreign_key: "recruitment_form_id"

    accepts_nested_attributes_for :form_fields, allow_destroy: true

    def self.common_fields
      fields = [:name, :lastname, :email].map do |attr|
        {
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.#{attr}"),
          options: {},
          type: "input-text"
        }
      end

        fields << {
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.starting_semester"),
          options: { choices: generate_next_admission_dates },
          type: "input-select"
        }
    end

  end
end
