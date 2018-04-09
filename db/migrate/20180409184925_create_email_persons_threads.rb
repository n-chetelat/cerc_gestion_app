class CreateEmailPersonsThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :email_persons_threads do |t|
      t.references :person, index: true, foreign_key: true
      t.references :email_thread, index: true, foreign_key: true

      t.timestamps
    end
  end
end
