ActiveAdmin.register RecruitmentInfo do
  menu false

  actions :index, :show, :update, :edit

  permit_params translations_attributes: [:id, :locale, :content]

  show do
    attributes_table do
      row(:content_en) { resource.content_en.try(:html_safe) }
      row(:content_fr) { resource.content_fr.try(:html_safe) }
    end
  end

  form do |f|
    f.inputs do
      f.translated_inputs "Translated field", switch_locale: false do |t|
        t.input :content, input_html: {class: "tinymce"}
      end
    end
    f.actions
  end

end
