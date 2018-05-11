ActiveAdmin.register RecruitmentInfo do
  menu false

  actions :index, :show, :update, :edit

  permit_params translations_attributes: [:id, :locale, :content, :copyright, :positions]

  show do
    attributes_table do
      row(:content_en) { resource.content_en.try(:html_safe) }
      row(:copyright_en)
      row(:positions_en)
      row(:content_fr) { resource.content_fr.try(:html_safe) }
      row(:copyright_fr)
      row(:positions_fr)
    end
  end

  form do |f|
    f.inputs do
      f.translated_inputs "Translated field", switch_locale: false do |t|
        t.input :content, input_html: {class: "tinymce"}
        t.input :copyright
        t.input :positions
      end
    end
    f.actions
  end

end
