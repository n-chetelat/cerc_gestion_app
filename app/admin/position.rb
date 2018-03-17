ActiveAdmin.register Position do
  menu parent: "Recruitment"

  permit_params translations_attributes: [:id, :locale, :_destroy, :title],
    recruitment_form_attributes: [:id, form_fields_attributes: [
      :id, :_destroy, :position, :form_cd, :label_en, :label_fr
      ]
    ]

  filter :title

  index do
    selectable_column
    id_column
    column :title
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
    end
    panel "Recruitment Form" do
      table_for resource.recruitment_form.form_fields do
        column :position
        column(:form_cd) {|form_field| te(form_field, :form)}
        column :label_en
        column :label_fr
      end
    end
  end

  form do |f|
    f.inputs do
      f.inputs "Translated fields" do
        f.translated_inputs "", switch_locale: false do |t|
          t.input :title
        end
      end
      panel "Recruitment Form" do

        f.inputs "", for: [:recruitment_form, f.object.recruitment_form || Positions::RecruitmentForm.new] do |a|
          a.has_many :form_fields, heading: "", allow_destroy: true, new_record: "New Form Field" do |b|
            Globalize.with_locale(:en) do
              b.input :label_en, label: "Label (en)"
            end
            Globalize.with_locale(:fr) do
              b.input :label_fr, label: "Label (fr)"
            end
            b.input :position
            b.input :form_cd, as: :select, collection: enum_option_pairs(Positions::FormField, :form, true)
          end
        end

      end
    end
    f.actions
  end

end
