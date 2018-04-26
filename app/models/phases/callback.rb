module Phases
  class Callback < ApplicationRecord

    self.table_name = "phases_callbacks"

    belongs_to :phase

    has_one :callbacks_email_template, class_name: "Phases::CallbackEmailTemplate", foreign_key: "phases_callback_id", dependent: :destroy, inverse_of: :phases_callback
    has_one :email_template, through: :callbacks_email_template

    def to_s
      self.title
    end

    def email_template_id
      self.email_template.try(:id)
    end

    def email_template_id=(template_id)
      return if template_id == self.email_template_id.to_s
      if template_id.blank?
        self.callbacks_email_template.destroy!
      else
        new_template = EmailTemplate.find(template_id.to_i)
        self.build_callbacks_email_template(email_template: new_template)
      end
    end

  end
end
