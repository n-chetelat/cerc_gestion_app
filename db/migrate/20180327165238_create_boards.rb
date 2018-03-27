class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    create_table :boards_phases do |t|
      t.references :board, index: true, foreign_key: true
      t.references :phase, index: true, foreign_key: true

      t.integer :position, default: 1

      t.timestamps
    end
  end
end
