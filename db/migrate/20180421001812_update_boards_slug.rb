class UpdateBoardsSlug < ActiveRecord::Migration[5.1]
  def change
    add_column :boards, :slug, :string
  end
end
