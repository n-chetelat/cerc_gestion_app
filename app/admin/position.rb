ActiveAdmin.register Position do

  permit_params translations_attributes: [:id, :locale, :_destroy, :title]

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
  end

  form do |f|
    f.inputs do
      f.inputs "Translated fields" do
        f.translated_inputs 'ignored title', switch_locale: false do |t|
          t.input :title
        end
      end
    end
    f.actions
  end

end
