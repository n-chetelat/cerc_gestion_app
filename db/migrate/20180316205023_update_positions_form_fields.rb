class UpdatePositionsFormFields < ActiveRecord::Migration[5.1]
  def change
    add_column :positions_form_fields, :position, :integer, default: 0
    add_column :positions_form_fields, :requirement_id, :integer, index: true
    add_column :positions_form_fields, :form_cd, :integer
  end
end
