ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :index, :new, :create, :update, :edit, :destroy

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :biography
    actions
  end

  filter :first_name
  filter :last_name
end
