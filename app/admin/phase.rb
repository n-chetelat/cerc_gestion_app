ActiveAdmin.register Phase do
  menu parent: "Boards"
  permit_params :title, :description, :initial, :final, :color, :no_color, :email_label_name,
    phases_callback_attributes: [:id, :_destroy, :title, :email_template_id]

  config.filters = false

  controller do
    after_action :broadcast_changes, only: [:create, :update, :destroy]

    def create
      resource = resource_class.create!(permitted_params[:phase])
      create_or_update_email_label(resource, params)
      resource.save!
      redirect_to admin_phase_path(resource)
    end

    def update
      super
      create_or_update_email_label(resource, params)
    end

    def destroy
      super
      email_service = ::EmailService.new(request)
      email_service.delete_email_label!(resource)
    end

    def create_or_update_email_label(resource, params)
      name = params[:phase][:email_label_name]
      email_service = ::EmailService.new(request)
      resource.email_label ||= resource.build_email_label
      if name.presence && (!resource.email_label.persisted? || resource.email_label.google_label_id.nil?)
        email_service.create_email_label!(resource, name)
      elsif name.blank? && resource.email_label.persisted?
        label_id = resource.email_label.google_label_id
        email_service.delete_email_label!(resource)
        PhaseService.update_email_labels(resource, [], [label_id], request)
        return
      elsif name.presence
        email_service.update_email_label!(resource, name)
      else
        return
      end
      label_id = resource.email_label.google_label_id
      PhaseService.update_email_labels(resource, [label_id], [], request)
    end

    private

      def broadcast_changes
        BoardChannelService.send_phases_update(resource.boards.pluck(:slug))
      end

  end

  index do
    selectable_column
    column :title
    column :initial
    column :final
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :color
      row :initial
      row :final
      row :email_label
      row(:description) { resource.description.try(:html_safe) }
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :color, input_html: { class: 'colorpicker' }
      f.input :no_color, as: :boolean, hint: "Select to remove theme color."
      f.input :email_label_name, hint: "The label you input here can only be associated with this tag!"
      if f.object.initial
        f.input :initial, hint: "This is currently the tag under which new applications are classified. Deselecting it does not move any existing persons to or from this tag."
      else
        f.input :initial, hint: "Is this the tag under which newly submitted applications are classified? Selecting this tag will deselect any other as initial. Existing persons will not be moved to or from this tag if selected."
      end
      f.input :final, hint: "An application moved to this category will be marked as closed as removed from the admin interface."
      f.input :description, input_html: {class: "tinymce"}
      f.inputs "", for: [:phases_callback, f.object.phases_callback || f.object.build_phases_callback] do |a|
        a.input :title
        a.input :email_template_id, as: :select, collection: EmailTemplate.limit(10).map {|t| [t.subject, t.id]}, input_html: {class: "select2"}
      end
    end
    f.actions
  end

  collection_action :autocomplete, method: :get do
    @list = resource_class

    if (filter = params[:q])
      filter = "%#{filter.parameterize(separator: '%')}%"

      @list = @list.where("title ILIKE ?", filter)
    else
      @list = @list.none
    end
    respond_with(@list)
  end

end
