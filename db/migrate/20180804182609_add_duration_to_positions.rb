class AddDurationToPositions < ActiveRecord::Migration[5.1]
  def change

    add_column :positions, :duration_units, :integer

  end
end
