class UpdatePhasesStarting < ActiveRecord::Migration[5.1]
  def change
    add_column :phases, :initial, :boolean, default: false
  end
end
