class UpdateApplicationsPosition < ActiveRecord::Migration[5.1]
  def change
    add_reference :applications, :position, index: true, foreign_key: true
  end
end
