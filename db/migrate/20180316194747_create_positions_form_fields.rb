class CreatePositionsFormFields < ActiveRecord::Migration[5.1]
  def change

    create_table :positions_form_fields do |t|
      t.references :recruitment_form, index: true
      t.jsonb :options, default: {}
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Positions::FormField.create_translation_table! label: {type: :string, null: false}
      end

      dir.down do
        Positions::FormField.drop_translation_table!
      end
    end

    add_foreign_key :positions_form_fields, :positions_recruitment_forms, column: :recruitment_form_id
  end
end
