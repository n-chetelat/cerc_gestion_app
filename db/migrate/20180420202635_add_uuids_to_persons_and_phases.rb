class AddUuidsToPersonsAndPhases < ActiveRecord::Migration[5.1]
  def change
    add_column :phases, :uuid, :uuid, unique: true
    add_column :persons, :uuid, :uuid, unique: true
  end
end
