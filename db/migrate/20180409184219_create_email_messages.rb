class CreateEmailMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :email_messages do |t|
      t.references :email_thread, index: true, foreign_key: true

      t.string :google_message_id
      t.string :google_timestamp
      t.string :google_label_ids, array: true

      t.text :content

      t.timestamps
    end
  end
end
