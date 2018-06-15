ActiveAdmin.register Board do
  menu parent: "Boards"
  permit_params :title, :description, boards_phases_attributes: [
    :id, :_destroy, :phase_id, :position, :final, :accepting
  ]

  # actions :index, :show, :update, :edit

  config.filters = false

  controller do
    after_action :broadcast_changes, only: [:create, :update, :destroy]

    private

      def broadcast_changes
        BoardChannelService.send_phases_update([resource.slug])
      end

  end

  index do
    selectable_column
    column :title
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row(:description) { resource.description.try(:html_safe) }
    end
    table_for resource.boards_phases.order(position: :asc) do
      orderable_handle_column url: :sort_admin_board_phase_path
      column :phase
      column :final
      column :accepting
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, input_html: {class: "tinymce"}
      unless f.object.new_record?
        f.inputs do
          f.has_many :boards_phases, sortable: :position, sortable_start: 1, heading: "", allow_destroy: true, new_record: "Add a Tag" do |a|
            a.input :phase_id, as: :select, collection: Phase.limit(10).map {|ph| [ph.title, ph.id]}, input_html: {class: "select2", data: {placeholder: "Select a Tag", "ajax--url" => autocomplete_admin_phases_url(:format => :json)}}
            a.input :final, wrapper_html: {class: "is-final"}, input_html: {class: "is-final-input"}
            a.input :accepting, label: "Indicates candidate is accepted?", wrapper_html: {class: "hideable"}
          end
        end
      else
        panel "" do
          para "N.B.: You must save the board before adding tags to it."
        end
      end
    end
    f.actions
  end

end
