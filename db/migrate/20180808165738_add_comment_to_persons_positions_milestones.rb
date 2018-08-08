class AddCommentToPersonsPositionsMilestones < ActiveRecord::Migration[5.1]
  def change
    add_column :persons_positions_milestones, :comment, :text
  end
end
