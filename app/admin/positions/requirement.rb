ActiveAdmin.register Positions::Requirement do
  menu false
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

  collection_action :autocomplete, method: :get do
    @list = resource_class.with_locales(I18n.locale).limit(5)

    if (params[:q].present?)
      filter = "%#{params[:q].parameterize(separator: '%')}%"
      ids = resource_class.translation_class.with_locales(I18n.locale)
        .where("label ILIKE ?", filter).select(:positions_requirement_id)
      @list = resource_class.where(id: ids)

    else
      @list = resource_class.none
    end

    respond_with(@list.limit(10))
  end

end
