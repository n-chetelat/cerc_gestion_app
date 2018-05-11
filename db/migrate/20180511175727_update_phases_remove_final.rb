class UpdatePhasesRemoveFinal < ActiveRecord::Migration[5.1]
  def change
    remove_column :phases, :final, :boolean
  end
end
