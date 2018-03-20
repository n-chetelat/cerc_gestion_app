class CreateRecruitmentInfosTranslations < ActiveRecord::Migration[5.1]
  def change
    remove_column :recruitment_infos, :content, :text

    reversible do |dir|
      dir.up do
        RecruitmentInfo.create_translation_table! content: {type: :text}
      end

      dir.down do
        RecruitmentInfo.drop_translation_table!
      end
    end

  end
end
