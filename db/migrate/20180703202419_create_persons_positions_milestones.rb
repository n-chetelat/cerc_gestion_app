class CreatePersonsPositionsMilestones < ActiveRecord::Migration[5.1]
  def change
    create_table :persons_positions_milestones do |t|
      t.references :person, index: true, foreign_key: true
      t.references :positions_milestone, index: true, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
