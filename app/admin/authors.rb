ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :all

  index do
    id_column
    column :first_name
    column :last_name
    actions defaults: false do |author|
      item t('.edit'), edit_admin_author_path(author), class: 'member_link'
      item t('.delete'), admin_author_path(author), method: :delete, data: { confirm: "#{t('.confirm_part1')} #{author.books.count} #{t('.confirm_part2')}" }, class: 'member_link'
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :biography
    end
    f.actions
  end

  filter :first_name
  filter :last_name

  controller do
    def destroy
      Author.find(params[:id]).discard
      flash[:notice] = 'Author has been deleted.'
      redirect_to admin_authors_path
    end
  end
end
