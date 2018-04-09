class UpdatePhasesGmailLabels < ActiveRecord::Migration[5.1]
  def change
    remove_column :phases, :gmail_label, :string
  end
end
