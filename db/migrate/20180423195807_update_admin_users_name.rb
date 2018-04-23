class UpdateAdminUsersName < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :lastname, :string
  end
end
