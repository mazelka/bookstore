class OrdersController < ApplicationController
  before_action :login_customer, only: :create_order

  def create_order
    if session[:order_id].nil?
      create_order_with_items
    else
      Order.find(session[:order_id])
    end
    redirect_to checkout_path(:address)
  end

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

  private

  def add_items_from_cart
    session[:cart].map do |item|
      create_item(item[:book_id], item[:quantity])
    end
  end

  def create_item(book_id, quantity)
    item = OrderItem.new(book: Book.find(book_id), quantity: quantity, order: @order)
    item.save
  end

  def login_customer
    redirect_to login_path unless customer_signed_in?
  end

  def create_order_with_items
    if session[:cart].nil?
      redirect_to cart_path
    else
      @order = Order.create(customer: current_customer, coupon: find_coupon)
      add_items_from_cart
      session[:order_id] = @order.id
      @order
    end
  end

  def find_coupon
    session[:coupon_id].nil? ? nil : Coupon.find(session[:coupon_id])
  end
end
