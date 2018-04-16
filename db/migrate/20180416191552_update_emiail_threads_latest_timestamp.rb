class UpdateEmiailThreadsLatestTimestamp < ActiveRecord::Migration[5.1]
  def change
    add_column :email_threads, :google_update_timestamp, :string
    rename_column :email_threads, :google_timestamp, :google_create_timestamp
  end
end
