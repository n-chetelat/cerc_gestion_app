class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :file_uid
      t.string :file_name

      t.timestamps
    end
  end
end
