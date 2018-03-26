class UpdatePositionsHidden < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :hidden, :boolean, default: false
  end
end
