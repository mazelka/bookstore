ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :all, except: [:show]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :biography
    actions exclude: :show
  end

  filter :first_name
  filter :last_name
end
