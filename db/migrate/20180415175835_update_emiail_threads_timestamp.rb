class UpdateEmiailThreadsTimestamp < ActiveRecord::Migration[5.1]
  def change
    add_column :email_threads, :google_timestamp, :string
  end
end
