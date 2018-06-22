class UpdatePersonsFinishedAt < ActiveRecord::Migration[5.1]
  def change
    add_column :persons, :finished_at, :datetime
  end
end
