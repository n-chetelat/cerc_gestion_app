ActiveAdmin.register AdminUser do
  permit_params :name, :lastname, :email, :password, :password_confirmation

  config.filters = false

  index do
    selectable_column
    id_column
    column :name
    column :lastname
    column :email
    column :current_sign_in_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :lastname
      row :email
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :lastname
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

end
