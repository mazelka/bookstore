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
    column 'Status', :aasm_state do |review|
      if review.approved?
        status_tag("#{review.aasm_state}", label: "#{review.aasm_state}", class: 'approved_tag')
      elsif review.rejected?
        status_tag("#{review.aasm_state}", label: "#{review.aasm_state}", class: 'rejected_tag')
      else
        status_tag("#{review.aasm_state}", label: "#{review.aasm_state}", class: 'unprocessed_tag')
      end
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
    end
  end

  action_item :approve, only: :show do
    if resource.unprocessed?
      link_to('Approve', approve_admin_review_path(resource), method: :post)
    end
  end

  action_item :reject, only: :show do
    if resource.unprocessed?
      link_to('Reject', reject_admin_review_path(resource), method: :post)
    end
  end

  member_action :approve, method: :post do
    resource.approve
    resource.save
    if resource.approved?
      redirect_to admin_review_path(resource), notice: 'This have been approved!'
    else
      p resource.errors
      redirect_to admin_review_path(resource), alert: 'Sorry, not all requirements were met for approving'
    end
  end

  member_action :reject, method: :post do
    resource.reject
    resource.save
    if resource.rejected?
      redirect_to admin_review_path(resource), notice: 'This have been rejected!'
    else
      p resource.errors
      redirect_to admin_review_path(resource), alert: 'Sorry, not all requirements were met for rejecting'
    end
  end
end
