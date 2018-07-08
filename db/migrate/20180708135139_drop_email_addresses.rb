class DropEmailAddresses < ActiveRecord::Migration[5.1]
  def change
    drop_table :email_addresses
  end
end
