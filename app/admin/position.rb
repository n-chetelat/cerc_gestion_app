ActiveAdmin.register Position do
  menu parent: "Recruitment"

  scope :all, default: true
  scope :visible
  scope :hidden

  permit_params :hidden,
  translations_attributes: [:id, :locale, :_destroy, :title],
    recruitment_form_attributes: [:id, form_fields_attributes: ([
      :id, :_destroy, :position, :form_cd, :choices,
      ] + Positions::FormField.globalize_attribute_names)
    ]

  config.filters = false

  sidebar :action, only: [:show] do
    para do
      button_to "Duplicate", duplicate_admin_position_path(resource), data: {confirm: "Are you sure?", disable_with: "In process..."}
    end
  end

  index do
    selectable_column
    column :title
    column :hidden
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :hidden
    end
    panel "Recruitment Form" do
      table_for resource.recruitment_form.form_fields.order(position: :asc) do
        orderable_handle_column url: :sort_admin_positions_form_field_path
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
      f.input :hidden
      if !f.object.new_record?
        panel "Recruitment Form" do
          para "N.B: Besides the fields below, each position's form asks for: #{Positions::RecruitmentForm.common_fields.map {|field| field[:label] }.join(", ")}.", class: "form-note"
          f.inputs "", for: [:recruitment_form, f.object.recruitment_form || Positions::RecruitmentForm.new] do |a|
            a.has_many :form_fields, sortable: :position, sortable_start: 1, heading: "", allow_destroy: true, new_record: "New Form Field" do |b|
              Globalize.with_locale(:en) do
                b.input :label_en, label: "Label (en)"
              end
              Globalize.with_locale(:fr) do
                b.input :label_fr, label: "Label (fr)"
              end


            b.input :form_cd, as: :select, collection: enum_option_pairs(Positions::FormField, :form, true), input_html: {class: "select2 has-choices"}
            b.input :choices, as: :text, placeholder: "Choice one in English; Choice one in French \nChoice two in English; Choice two in French", hint: "Separate translations (English, then French) by a semi-colon (;) and choices by a new line.", wrapper_html: {class: "hideable"}
            end
          end

        end
      end
    end
    f.actions
  end

  member_action :duplicate, :method => [:post] do
    resource.duplicate!
    redirect_to admin_positions_path
  end

end
