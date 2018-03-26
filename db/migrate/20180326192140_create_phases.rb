class CreatePhases < ActiveRecord::Migration[5.1]
  def change
    create_table :phases do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    create_table :persons_phases do |t|
      t.references :phase, index: true, foreign_key: true
      t.references :person, index: true, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
