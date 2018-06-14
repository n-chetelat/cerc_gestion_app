class UpdateApplicationsClosedAt < ActiveRecord::Migration[5.1]
  def change
    remove_column :applications, :to_delete, :boolean
    add_column :applications, :closed_at, :datetime
  end
end
