ActiveAdmin.register Board do
  menu parent: "Boards"
  permit_params :title, :description, boards_phases_attributes: [
    :id, :_destroy, :phase_id, :position
  ]

  config.filters = false

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
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, input_html: {class: "tinymce"}
      f.inputs do
        f.has_many :boards_phases, sortable: :position, sortable_start: 1, heading: "", allow_destroy: true, new_record: "Add a Tag" do |a|
          a.input :phase_id, as: :select, collection: Phase.limit(10).map {|ph| [ph.title, ph.id]}, input_html: {class: "select2", data: {placeholder: "Select a Tag", "ajax--url" => autocomplete_admin_phases_url(:format => :json)}}
        end
      end
    end
    f.actions
  end

end
