class UpdateEmailThreadsHistory < ActiveRecord::Migration[5.1]
  def change
    add_column :email_threads, :google_history_id, :string
  end
end
