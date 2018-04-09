class CreateEmailAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :email_addresses do |t|
      t.string :address
      t.references :person, index: true, foreign_key: true
    end
  end
end
