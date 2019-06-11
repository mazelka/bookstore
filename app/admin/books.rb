ActiveAdmin.register Book do
  permit_params :title, :description, :price, :count, :author_id, :category_id, :review_id, :cover
  actions :index, :new, :show, :create, :update, :edit, :destroy

  index do
    selectable_column
    id_column
    column :title
    column :author do |i|
      "#{i.author.first_name} #{i.author.last_name}"
    end
    column :category
    column :price
    column :count

    actions
  end

  filter :title
  filter :author, as: :select, collection: proc { Author.all.map { |author| ["#{author.last_name}, #{author.first_name}", author.id] } }

  show do
    attributes_table do
      row :title
      row :cover do |book|
        image_tag(book.cover_url(:thumb))
      end
      row :description
      row :author do |i|
        "#{i.author.first_name} #{i.author.last_name}"
      end
      row :category
      row :price
      row :count
      row :review do |book|
        book.reviews
      end
    end
  end

  form do |f|
    f.inputs 'Book' do
      f.input :title, required: true
      f.input :cover, as: :file, :hint => image_tag(f.object.cover.url(:thumb))
      f.input :author, as: :select, collection: Author.all.map { |author| ["#{author.last_name}, #{author.first_name}", author.id] }
      f.input :category, as: :select, collection: Category.all
    end
    f.button :Save
    f.button :Cancel
  end
end
