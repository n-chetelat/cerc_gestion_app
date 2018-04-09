class CreateEmailThread < ActiveRecord::Migration[5.1]
  def change
    create_table :email_threads do |t|
      t.string :google_thread_id, null: false

      t.timestamps
    end

  end
end
