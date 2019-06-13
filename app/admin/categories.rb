ActiveAdmin.register Category do
  permit_params :title
  actions :all, except: [:show]

  index do
    selectable_column
    id_column
    column :title
  end

  filter :title
end
