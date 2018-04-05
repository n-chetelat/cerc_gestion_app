ActiveAdmin.register EmailTemplate do
  menu parent: "Boards"

  permit_params :locale, translations_attributes: [:id, :locale, :subject, :body]

  config.filters = false

  index do
    selectable_column
    column :subject
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :subject_en
      row(:body_en) { resource.body_en.try(:html_safe) }
      row :subject_fr
      row(:body_fr) { resource.body_fr.try(:html_safe) }
    end
  end

  form do |f|
    div "", style: "border: 1px solid black; padding: 5px;" do
      h3 "Including variables in the template"
      para <<~PARA
        You can include a variable in double brackets ({{}})
        to substitute it in the email for the recipient's information.
      PARA
      para <<~PARA
        The following properties will be substituted for the recipient's:
        #{EmailTemplate::TEMPLATE_VARIABLES.join(", ")}.
      PARA
      para "E.g.: Dear {{full_name}}..."
    end

    f.inputs do
      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :subject
        t.input :body, input_html: {class: "tinymce"}
      end
    end
    f.actions
  end

end
