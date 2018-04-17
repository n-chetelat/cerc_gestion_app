class UpdateEmailMessagesToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :email_messages, :to_addresses, :string, array: true
  end
end
