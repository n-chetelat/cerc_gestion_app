class CreatePersons < ActiveRecord::Migration[5.1]
  def change
    create_table :persons do |t|
      t.string :name
      t.string :lastname
      t.string :email

      t.timestamps
    end

  end
end
