class CreatePositionsRecruitmentForms < ActiveRecord::Migration[5.1]
  def change
    create_table :positions_recruitment_forms do |t|
      t.references :position, index: true, foreign_key: true
      t.timestamps
    end
  end
end
