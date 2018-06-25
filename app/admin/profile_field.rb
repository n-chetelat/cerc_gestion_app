ActiveAdmin.register ProfileField do
  menu parent: "Timeline"
  config.filters = false

  permit_params :label, :form_cd, :optional, :choices

  index do
    column :label
    column(:form_cd) {|form_field| te(form_field, :form)}
    column :optional
    actions
  end

  show do
    attributes_table do
      row :label
      row(:form_cd) { te(resource, :form) }
      row :optional
      row(:choices) { (resource.choices_with_locale(:en) || []).map {|ch| ch[:label] }.to_sentence }
    end
  end

  form do |f|
    f.inputs do
      f.input :label
      f.input :form_cd, as: :select, collection: (enum_option_pairs(ProfileField, :form, true).reject {|r| ProfileField::UPLOADS.include?(r[1]) }), input_html: {class: "select2 has-choices"}
      f.input :optional
      f.input :choices, as: :text, placeholder: "Choice one in English; Choice one in French \nChoice two in English; Choice two in French", hint: "Separate translations (English, then French) by a semi-colon (;) and choices by a new line.", wrapper_html: {class: "profiles-hideable"}
    end
    f.actions
  end

end
