module Positions
  class RecruitmentForm < ApplicationRecord

    self.table_name = "positions_recruitment_forms"

    attr_accessor :name, :lastname, :email

    belongs_to :position
    has_many :form_fields, class_name: "Positions::FormField", dependent: :destroy, foreign_key: "recruitment_form_id"

    accepts_nested_attributes_for :form_fields, allow_destroy: true

    def self.common_fields
      [:name, :lastname, :email].map do |attr|
        {
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.#{attr}"),
          options: {},
          type: "input-text"
        }
      end
    end

  end
end
