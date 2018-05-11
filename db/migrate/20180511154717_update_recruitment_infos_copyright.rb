class UpdateRecruitmentInfosCopyright < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitment_info_translations, :copyright, :string
    add_column :recruitment_info_translations, :positions, :string
  end
end
