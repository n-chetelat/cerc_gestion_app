class UpdateEmailTemplates < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :email_templates, column: "phases_callback_id"
  end
end
