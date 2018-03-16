class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Position.create_translation_table! title: {type: :string, null: false}
      end

      dir.down do
        Position.drop_translation_table!
      end
    end

  end
end
