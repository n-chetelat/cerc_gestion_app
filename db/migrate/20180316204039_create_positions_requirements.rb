class CreatePositionsRequirements < ActiveRecord::Migration[5.1]
  def change
    create_table :positions_requirements do |t|
      t.integer :form_cd
      t.timestamps
    end

    # reversible do |dir|
    #   dir.up do
    #     Positions::Requirement.create_translation_table! label: {type: :string, null: false}
    #   end
    #
    #   dir.down do
    #     Positions::Requirement.drop_translation_table!
    #   end
    # end

  end
end
