class AddOptionsToPositions < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :options, :jsonb, default: {}
  end
end
