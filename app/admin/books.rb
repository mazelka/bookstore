require 'money'

ActiveAdmin.register Book do
  actions :all, except: [:destroy]
  permit_params :title, :description, :price, :inventory, :author_id, :category_id, :review_id, :cover

  index do
    selectable_column
    id_column
    column :title
    column :author do |i|
      "#{i.author.first_name} #{i.author.last_name}"
    end
    column :category
    column :price do |book|
      Money.new(book.price).format
    end
    column :inventory

    actions
  end

  filter :title
  filter :author, as: :select, collection: proc { Author.all.map { |author| ["#{author.last_name}, #{author.first_name}", author.id] } }

  show do
    attributes_table do
      row :title
      row :cover do |book|
        image_tag(book.cover_url(:thumb)) unless book.cover_url.nil?
      end
      row :description
      row :author do |i|
        "#{i.author.first_name} #{i.author.last_name}"
      end
      row :category
      row :price do |book|
        Money.new(book.price).format
      end
      row :inventory
      row :review do |book|
        book.reviews
      end
    end
  end

  form do |f|
    f.object.price = f.object.price / 100 unless f.object.price.nil?
    f.inputs 'Book' do
      f.input :title, required: true
      f.input :price, required: true
      f.input :inventory, required: true
      f.input :cover, as: :file
      f.input :description
      f.input :author, as: :select, collection: Author.all.map { |author| ["#{author.last_name}, #{author.first_name}", author.id] }
      f.input :category, as: :select, collection: Category.all
    end
    f.button :Save
    f.button :Cancel
  end

  action_item :discard, only: :show do
    link_to('Delete', discard_admin_book_path(book), method: :post)
  end

  member_action :discard, method: :post do
    if resource.discard
      redirect_to admin_books_path, notice: 'Book was deleted!'
    else
      redirect_to admin_books_path, alert: 'Sorry, not all requirements were met for deleting'
    end
  end
end
