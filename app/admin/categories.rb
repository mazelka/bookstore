ActiveAdmin.register Category do
  permit_params :title
  actions :index, :new, :create, :update, :edit, :destroy

  index do
    selectable_column
    id_column
    column :title
  end
end
