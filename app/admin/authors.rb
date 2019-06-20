ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :all, except: [:show, :destroy]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :biography
    actions defaults: true do |author|
      link_to 'Delete', author_path(author), method: :delete, data: { confirm: "Are you sure you want to delete this author? They are associated with #{author.books.count} books." }
    end
  end

  filter :first_name
  filter :last_name
end
