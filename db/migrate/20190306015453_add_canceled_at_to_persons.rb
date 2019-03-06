class AddCanceledAtToPersons < ActiveRecord::Migration[5.1]
  def change
    add_column :persons, :canceled_at, :datetime
  end
end
