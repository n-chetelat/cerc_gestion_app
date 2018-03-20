class UpdateRecruitmentInfos < ActiveRecord::Migration[5.1]
  def up
    execute "CREATE RULE recruit_info_del_protect AS ON DELETE TO recruitment_infos DO INSTEAD NOTHING;"
  end

end
