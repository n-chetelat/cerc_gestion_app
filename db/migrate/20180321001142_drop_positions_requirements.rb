class DropPositionsRequirements < ActiveRecord::Migration[5.1]
  def change
    drop_table :positions_requirements
  end
end
