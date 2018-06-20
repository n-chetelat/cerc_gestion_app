class CreatePersonsProfileFields < ActiveRecord::Migration[5.1]
  def change
    create_table :persons_profile_fields do |t|
      t.references :person, index: true, foreign_key: true
      t.references :profile_field, index: true, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end
