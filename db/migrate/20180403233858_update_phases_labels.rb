class UpdatePhasesLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :phases, :gmail_label, :string
  end
end
