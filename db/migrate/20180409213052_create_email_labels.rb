class CreateEmailLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :email_labels do |t|
      t.string :name
      t.string :google_label_id
      t.references :phase, index: true, foreign_key: true

      t.timestamps
    end
  end
end
