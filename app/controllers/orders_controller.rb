class OrdersController < ApplicationController
  def index
    @orders = current_customer.orders
    @orders_sorting = 'All'
  end

  def in_progress
    @orders = current_customer.orders.in_progress
    @orders_sorting = 'In Progress'
    render 'index'
  end

  def in_delivery
    @orders = current_customer.orders.in_delivery
    @active_sorting = 'In Delivery'
    render 'index'
  end

  def canceled
    @orders = current_customer.orders.canceled
    @active_sorting = 'Canceled'
    render 'index'
  end
end
