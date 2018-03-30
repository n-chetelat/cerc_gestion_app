class CreateEmailTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :email_templates do |t|

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        EmailTemplate.create_translation_table! subject: :string, body: :text
      end

      dir.down do
        EmailTemplate.drop_translation_table!
      end
    end

  end
end
