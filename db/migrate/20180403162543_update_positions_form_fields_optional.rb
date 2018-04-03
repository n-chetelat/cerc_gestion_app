class UpdatePositionsFormFieldsOptional < ActiveRecord::Migration[5.1]
  def change
    add_column :positions_form_fields, :optional, :boolean, default: false
  end
end
