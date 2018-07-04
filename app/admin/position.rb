ActiveAdmin.register Position do
  menu parent: "Recruitment"

  scope :all, default: true
  scope :visible
  scope :hidden

  permit_params :hidden, :time_interval_cd, :position,
  translations_attributes: [:id, :locale, :_destroy, :title],
    recruitment_form_attributes: [:id, form_fields_attributes: ([
      :id, :_destroy, :position, :form_cd, :optional, :choices,
      ] + Positions::FormField.globalize_attribute_names)
    ],
    milestones_attributes: [:id, :_destroy, :title, :description,
      :time_interval_ordinality]

  config.filters = false
  config.sort_order = "position_asc"
  orderable

  sidebar :action, only: [:show] do
    para do
      button_to "Duplicate", duplicate_admin_position_path(resource), data: {confirm: "Are you sure?", disable_with: "In process..."}
    end
  end

  index do
    selectable_column
    orderable_handle_column url: :sort_admin_position_path
    column :position
    column :title
    column :hidden
    column :updated_at

    actions defaults: false do |resource|
      item "View", admin_position_path(resource)
      text_node "&nbsp".html_safe
      item "Edit", edit_admin_position_path(resource)
      text_node "&nbsp".html_safe
      if resource.applications.empty?
        item "Delete", admin_position_path(resource), method: :delete
      else
        link_to "Delete", "#", data: { :confirm => "You cannot delete this Position!\nIt is currently tied to one or more applications.\nPlease finalize all the applications related to this position in order to delete it." }
      end
    end
  end

  show do
    attributes_table do
      row :title
      row :hidden
      row :position
      row(:time_interval_cd) { te(resource, :time_interval) }
    end
    panel "Recruitment Form" do
      table_for resource.recruitment_form.form_fields.order(position: :asc) do
        orderable_handle_column url: :sort_admin_positions_form_field_path
        column(:form_cd) {|form_field| te(form_field, :form)}
        column :optional
        column :label_en
        column :label_fr
      end
    end
    panel "Milestones" do
      table_for resource.milestones.order(time_interval_ordinality: :asc) do
        orderable_handle_column url: :sort_admin_positions_milestone_path
        column :title
        column :description
        column :time_interval_ordinality
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
      f.input :position
      f.input :time_interval_cd, as: :select, collection: enum_option_pairs(Position, :time_interval, true), hint: "The starting date for the applicant will be divided into this unit.", input_html: {class: "select2"}
      if !f.object.new_record?
        panel "Recruitment Form" do
          para "N.B: Besides the fields below, each position's form asks for: #{f.object.recruitment_form.common_fields.map {|field| field[:label] }.join(", ")}.", class: "form-note"

          # Recruitment Form
          f.inputs "", for: [:recruitment_form, f.object.recruitment_form || Positions::RecruitmentForm.new] do |a|
            a.has_many :form_fields, sortable: :position, sortable_start: 1, heading: "", allow_destroy: true, new_record: "New Form Field" do |b|
              Globalize.with_locale(:en) do
                b.input :label_en, label: "Label (en)"
              end
              Globalize.with_locale(:fr) do
                b.input :label_fr, label: "Label (fr)"
              end


            b.input :form_cd, as: :select, collection: enum_option_pairs(Positions::FormField, :form, true), input_html: {class: "select2 has-choices"}
            b.input :optional
            b.input :choices, as: :text, placeholder: "Choice one in English; Choice one in French \nChoice two in English; Choice two in French", hint: "Separate translations (English, then French) by a semi-colon (;) and choices by a new line.", wrapper_html: {class: "hideable"}
            end
          end

          # Milestones
          f.inputs do
            f.has_many :milestones, sortable: :time_interval_ordinality, sortable_start: 1, heading: "", allow_destroy: true, new_record: "Add a Milestone" do |a|
              a.input :title
              a.input :description, input_html: {class: "small-textbox"}
              a.input :time_interval_ordinality, hint: "On which semester/month the milestone needs to be completed."

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
