module Phases
  class CallbackEmailTemplate < ApplicationRecord

    self.table_name = "phases_callbacks_email_templates"

    belongs_to :phases_callback, class_name: "Phases::Callback", foreign_key: "phases_callback_id", inverse_of: :callbacks_email_template
    belongs_to :email_template, class_name: "EmailTemplate", foreign_key: "email_template_id", inverse_of: :callbacks_email_templates

  end
end
