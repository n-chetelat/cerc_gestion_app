class UpdateBoardsPhasesFinal < ActiveRecord::Migration[5.1]
  def change
    add_column :boards_phases, :final, :boolean, defaul: false
  end
end
