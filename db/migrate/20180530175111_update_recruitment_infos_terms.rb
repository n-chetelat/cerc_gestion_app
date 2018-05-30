class UpdateRecruitmentInfosTerms < ActiveRecord::Migration[5.1]
  def change
    add_column :recruitment_info_translations, :terms, :text
  end
end
