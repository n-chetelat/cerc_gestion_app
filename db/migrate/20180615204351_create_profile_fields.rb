class CreateProfileFields < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_fields do |t|
      t.string :label
      t.integer :form_cd, default: 0
      t.jsonb :options, default: {}
      t.boolean :optional, default: true

      t.timestamps
    end
  end
end
