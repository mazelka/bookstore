ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :all, except: [:destroy, :show, :new]

  index do
    id_column
    column :first_name
    column :last_name
    column :biography
    actions defaults: false do |author|
      link_to 'Delete', admin_author_path(author), method: :delete, data: { confirm: "Are you sure you want to delete this author? They are associated with #{author.books.count} books." }
    end
  end

  filter :first_name
  filter :last_name

  controller do
    def destroy
      Author.find(params[:id]).destroy
      flash[:notice] = 'Author has been deleted.'
      redirect_to admin_authors_path
    end
  end
end
