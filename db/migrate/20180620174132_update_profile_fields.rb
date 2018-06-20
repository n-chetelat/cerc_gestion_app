class UpdateProfileFields < ActiveRecord::Migration[5.1]
  def change
    add_column :profile_fields, :form_field_id, :integer
  end
end
