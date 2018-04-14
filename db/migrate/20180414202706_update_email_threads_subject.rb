class UpdateEmailThreadsSubject < ActiveRecord::Migration[5.1]
  def change
    add_column :email_threads, :subject, :string
  end
end
