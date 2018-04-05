class RecreateEmailTemplates < ActiveRecord::Migration[5.1]

  def change
    EmailTemplate.drop_translation_table!
    execute "DROP TABLE email_templates CASCADE;"

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

  create_table :phases_callbacks_email_templates do |t|
    t.references :email_template, index: true, foreign_key: true
    t.references :phases_callback, index: true, foreign_key: true

    t.timestamps
  end

end
