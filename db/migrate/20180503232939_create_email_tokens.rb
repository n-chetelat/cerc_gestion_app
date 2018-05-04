class CreateEmailTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :email_tokens do |t|
      t.string :token, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
