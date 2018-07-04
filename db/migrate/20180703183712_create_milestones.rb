class CreateMilestones < ActiveRecord::Migration[5.1]
  def change
    create_table :positions_milestones do |t|
      t.references :position, index: true, position: true
      t.string :title
      t.text :description
      t.integer :time_interval_ordinality # on which semester/month it is to be applied

      t.timestamps
    end
  end
end
