class UpdatePositionsTimeInterval < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :time_interval_cd, :integer, default: 0
  end
end
