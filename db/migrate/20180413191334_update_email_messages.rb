class UpdateEmailMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :email_messages, :google_label_ids, :string
    add_column :email_messages, :from_address, :string
  end
end
