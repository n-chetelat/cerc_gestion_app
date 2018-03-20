class CreateRecruitmentInfo < ActiveRecord::Migration[5.1]
  def change
    create_table :recruitment_infos do |t|
      t.text :content
      t.integer :singleton_guard, default: 0

      t.timestamps
    end
  end
end
