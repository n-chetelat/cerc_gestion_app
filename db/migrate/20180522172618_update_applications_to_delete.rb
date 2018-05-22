class UpdateApplicationsToDelete < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :to_delete, :boolean, default: false
  end
end
