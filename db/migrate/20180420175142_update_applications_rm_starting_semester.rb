class UpdateApplicationsRmStartingSemester < ActiveRecord::Migration[5.1]
  def change
    remove_column :applications, :starting_semester, :date
  end
end
