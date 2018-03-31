class CreateCallbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :phases_callbacks do |t|
      t.string :title
      t.references :phase, index: true, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_column :email_templates, :phases_callback_id, :integer, index: true
    add_foreign_key :email_templates, :phases_callbacks, column: :phases_callback_id
  end
end
