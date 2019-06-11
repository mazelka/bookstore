ActiveAdmin.register Review do
  permit_params :title, :text, :customer, :book
  actions :index, :show, :update

  index do
    selectable_column
    id_column
    column :title do |review|
      link_to review.title, "reviews/#{review.id}"
    end
    column :customer do |i|
      "#{i.customer.first_name} #{i.customer.last_name}"
    end
    column :book

    actions
  end

  filter :title
  filter :customer, as: :select, collection: -> { Customer.all.map { |customer| ["#{customer.last_name}, #{customer.first_name}", customer.id] } }

  show do
    attributes_table do
      row :title
      row :book
      row :customer do |i|
        "#{i.customer.first_name} #{i.customer.last_name}"
      end
      row :text
    end
  end

  # form do |f|
  #   f.inputs 'Book' do
  #     f.input :title, required: true
  #     f.input :author, as: :select, collection: -> { Author.all.map { |author| ["#{author.last_name}, #{author.first_name}", author.id] } }
  #     f.input :category, as: :select, collection: Category.all
  #   end
  #   f.button :Save
  #   f.button :Cancel
  # end
end
