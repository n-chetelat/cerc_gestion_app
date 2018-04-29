class UpdatePhasesFinal < ActiveRecord::Migration[5.1]
  def change
    add_column :phases, :final, :boolean, defaul: false
  end
end
