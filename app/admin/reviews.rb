ActiveAdmin.register Review do
  permit_params :title, :text, :customer, :book
  actions :all, except: [:destroy, :new, :edit]

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
end
