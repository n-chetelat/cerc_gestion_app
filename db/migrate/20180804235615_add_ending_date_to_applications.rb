class AddEndingDateToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :ending_date, :date
  end
end
