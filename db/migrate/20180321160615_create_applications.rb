class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.references :person, index: true, foreign_key: true
      t.string :locale
      t.date :starting_semester
      t.jsonb :fields, default: {}

      t.timestamps
    end
  end
end
