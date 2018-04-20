class UpdateApplicationsStartingDate < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :starting_date, :date
  end
end
