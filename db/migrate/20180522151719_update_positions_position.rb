class UpdatePositionsPosition < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :position, :integer
  end
end
