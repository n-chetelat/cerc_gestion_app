module Positions
  class RecruitmentForm < ApplicationRecord

    self.table_name = "positions_recruitment_forms"

    attr_accessor :name, :lastname, :email, :starting_date

    belongs_to :position
    has_many :form_fields, class_name: "Positions::FormField", dependent: :destroy, foreign_key: "recruitment_form_id"

    accepts_nested_attributes_for :form_fields, allow_destroy: true

    def common_fields
      fields = self.class.immutable_common_fields

        fields << {
          id: "starting_date",
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.starting_date"),
          options: { choices: ::DatesService.generate_starting_dates(self.position.time_interval) },
          type: "input-select"
        }
    end

    def self.immutable_common_fields
      fields = [:name, :lastname, :email].map do |attr|
        {
          id: attr.to_s,
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.#{attr}"),
          options: {},
          type: "input-text"
        }
      end
    end

  end
end
