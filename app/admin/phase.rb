ActiveAdmin.register Phase do
  permit_params :title, :description, :initial

  config.filters = false

  index do
    selectable_column
    column :title
    column :initial
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :initial
      row(:description) { resource.description.try(:html_safe) }
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      if f.object.initial
        f.input :initial, hint: "This is currently the tag under which new applications are classified. Deselecting it does not move any existing persons to or from this tag."
      else
        f.input :initial, hint: "Is this the tag under which newly submitted applications are classified? Selecting this tag will deselect any other as initial. Existing persons will not be moved to or from this tag if selected."
      end
      f.input :description, input_html: {class: "tinymce"}
    end
    f.actions
  end

end
