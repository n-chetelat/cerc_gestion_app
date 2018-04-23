class CreateApplicationsComments < ActiveRecord::Migration[5.1]
  def change
    create_table :applications_comments do |t|
      t.text :content, null: false
      t.references :application, index: true, foreign_key: true
      t.integer :author_id, index: true

      t.timestamps
    end

  end
end
