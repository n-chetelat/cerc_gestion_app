module Phases
  class Callback < ApplicationRecord

    self.table_name = "phases_callbacks"

    belongs_to :phase
    has_one :email_template, class_name: "EmailTemplate", dependent: :destroy, foreign_key: "phases_callback_id", inverse_of: :phase_callback

    acts_as_list scope: :phase

    def to_s
      self.title
    end

    def email_template_id
      self.email_template.try(:id)
    end

    def email_template_id=(template_id)
      return if template_id == self.email_template_id.to_s
      if template_id.blank?
        self.email_template = nil
      else
        new_template = EmailTemplate.find(template_id.to_i)
        self.email_template = new_template
      end
    end

  end
end
