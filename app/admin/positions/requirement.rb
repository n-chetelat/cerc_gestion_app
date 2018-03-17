ActiveAdmin.register Positions::Requirement do
  menu parent: "Recruitment"
  permit_params :form_cd, translations_attributes: [:id, :locale, :label]

  filter :label

  index do
    selectable_column
    id_column
    column :label
    column(:form) {|resource| te(resource, :form)}
    actions
  end

  show do
    attributes_table do
      row :label
      row(:form) {|resource| te(resource, :form)}
    end
  end

  form do |f|
    f.inputs do
      f.inputs do
        f.translated_inputs "Translated field", switch_locale: false do |t|
          t.input :label
        end
        f.input :form_cd, as: :select, collection: enum_option_pairs(Positions::FormField, :form, true)
      end
    end
    f.actions
  end

end
