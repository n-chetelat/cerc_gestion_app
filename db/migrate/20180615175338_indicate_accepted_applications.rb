class IndicateAcceptedApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :boards_phases, :accepting, :boolean, default: false
    add_column :applications, :accepted, :boolean, default: false
  end
end
