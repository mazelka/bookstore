include ActiveAdminHelpers
ActiveAdmin.register Review do
  permit_params :title, :text, :customer, :book
  actions :all, except: [:destroy, :edit, :new]

  scope :unprocessed
  scope :approved
  scope :rejected

  index do
    selectable_column
    column :title do |review|
      link_to review.title, "reviews/#{review.id}"
    end
    column :customer do |i|
      "#{i.customer.first_name} #{i.customer.last_name}"
    end
    column :book
    column t('.status'), :aasm_state do |review|
      state = review.aasm_state
      status_tag(state.to_s, label: state.to_s, class: customize_status_tag(state))
    end

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
      row t('.status'), :aasm_state do |review|
        state = review.aasm_state
        status_tag(state.to_s, label: state.to_s, class: customize_status_tag(state))
      end
    end
  end

  action_item :approve, only: :show do
    link_to(t('.approve'), approve_admin_review_path(resource), method: :post) if resource.unprocessed?
  end

  action_item :reject, only: :show do
    link_to(t('.reject'), reject_admin_review_path(resource), method: :post) if resource.unprocessed?
  end

  member_action :approve, method: :post do
    if resource.approve!
      redirect_to admin_review_path(resource), notice: t('.notice')
    else
      redirect_to admin_review_path(resource), alert: t('.alert')
    end
  end

  member_action :reject, method: :post do
    if resource.reject!
      redirect_to admin_review_path(resource), notice: t('.notice')
    else
      redirect_to admin_review_path(resource), alert: t('.alert')
    end
  end
end
