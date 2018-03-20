ActiveAdmin.register RecruitmentInfo do
  menu false

  actions :index, :show, :update, :edit

  permit_params :content

  index do
    selectable_column
    actions
  end

  show do
    attributes_table do
      row(:content) { resource.content.try(:html_safe) }
    end
  end

  form do |f|
    f.inputs do
      f.input :content, input_html: {class: "tinymce"}
    end
    f.actions
  end

end
