include ActiveAdminHelpers

ActiveAdmin.register Order do
  permit_params :total_price, :aasm_state, :created_at, :updated_at, order_items_attributes: [:book, :quantity, :order_id]
  actions :all, except: [:destroy, :edit, :new]

  scope :in_progress
  scope :delivered
  scope :canceled

  index do
    selectable_column
    column :customer do |i|
      "#{i.customer.first_name} #{i.customer.last_name}"
    end
    column t('.status'), :aasm_state do |order|
      state = order.aasm_state
      status_tag(state.to_s, label: state.to_s, class: customize_status_tag(state))
    end
    column :updated_at

    actions
  end

  filter :aasm_state
  filter :customer, as: :select, collection: -> { Customer.all.map { |customer| ["#{customer.last_name}, #{customer.first_name}", customer.id] } }

  show do
    attributes_table do
      row :customer do |i|
        "#{i.customer.first_name} #{i.customer.last_name}"
      end
      row t('.items'), :order_items do |order|
        order_items_details(order)
      end
      row :total_price do |order|
        Money.new(order.total_price).format
      end
      row :delivery do |order|
        order.delivery.present? ? order.delivery.name : nil
      end

      row :payment do |order|
        payment = order.payment.present? ? 'PAID' : 'NOT PAID'
        status_tag(payment, label: payment, class: customize_payment_tag(payment))
      end
      row t('.status'), :aasm_state do |order|
        state = order.aasm_state
        status_tag(state.to_s, label: state.to_s, class: customize_status_tag(state))
      end
      row :updated_at
      row :created_at
    end
  end

  action_item :start_delivery, only: :show do
    link_to(t('.in_delivery'), start_delivery_admin_order_path(resource), method: :post) if resource.in_queue?
  end

  action_item :finish_delivery, only: :show do
    link_to(t('.delivered'), finish_delivery_admin_order_path(resource), method: :post) if resource.in_delivery?
  end

  action_item :cancel, only: :show do
    link_to(t('.cancel'), cancel_admin_order_path(resource), method: :post) unless resource.in_progress? || resource.canceled?
  end

  member_action :start_delivery, method: :post do
    if resource.start_delivery!
      redirect_to admin_order_path(resource), notice: t('.in_delivery')
    else
      redirect_to admin_order_path(resource), alert: t('.failed_start_delivery')
    end
  end

  member_action :finish_delivery, method: :post do
    if resource.finish_delivery!
      redirect_to admin_order_path(resource), notice: t('.delivered')
    else
      redirect_to admin_order_path(resource), alert: t('.delivery_failed')
    end
  end

  member_action :cancel, method: :post do
    if resource.cancel!
      redirect_to admin_order_path(resource), notice: t('.canceled')
    else
      redirect_to admin_order_path(resource), alert: t('.cancel_failed')
    end
  end
end
