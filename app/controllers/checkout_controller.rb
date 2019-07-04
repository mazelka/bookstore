class CheckoutController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_customer!
  steps :address, :delivery, :payment, :confirmation, :complete

  def show
    cart_details
    case step
    when :address
      create_order_with_items
      @order = get_order
    when :delivery
      @order = get_order
      @delivery = Delivery.all
    when :payment
      @order = get_order
    when :confirmation
      @order = get_order
    else
      p 'asd'
    end
    @shipping_addresses = current_customer.addresses || []
    render_wizard
  end

  def update
    @order = get_order
    case step
    when :address
      UpdateOrderAddress.new(@order, address_params).update
    when :delivery
      UpdateOrderDelivery.new(@order, delivery_params).update
    when :payment
      UpdateOrderPayment.new(@order, payment_params).update
    when :confirmation
      session[:cart] = @items
    else
      p 'asD'
    end
    binding.pry
    render_wizard(@order)
    session[:order_id] = @order.id
  end

  def customer_has_address?
    current_customer.addresses.exists?
  end

  def order_has_address?
    order.shipping_address.exists?
  end

  def get_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new(customer: current_customer)
    end
  end

  def create_order_with_items
    @order = Order.create(customer: current_customer)
    items_from_cart
    session[:order_id] = @order.id
  end

  def cart_details
    @coupon = session[:coupon] || 0
    @cart = find_order
    @cart_details = CartDetails.new(@cart, @coupon)
  end

  # def __create
  #   session[:order_params].deep_merge!(params[:order]) if params[:order]
  #   @order = Order.new(session[:order_params])
  #   @order.current_step = session[:order_step]
  #   if @order.valid?
  #     if params[:back_button]
  #       @order.previous_step
  #     elsif @order.last_step?
  #       @order.save if @order.all_valid?
  #     else
  #       @order.next_step
  #     end
  #     session[:order_step] = @order.current_step
  #   end
  #   if @order.new_record?
  #     render 'new'
  #   else
  #     session[:order_step] = session[:order_params] = nil
  #     flash[:notice] = 'Order saved!'
  #     redirect_to @order
  #   end
  # end

  def items_from_cart
    session[:cart].map do |item|
      create_item(item[:book_id], item[:quantity])
    end
  end

  def create_item(book_id, quantity)
    item = OrderItem.new(book: Book.find(book_id), quantity: quantity, order: @order)
    item.save
  end

  def address_params
    params.permit({ shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end

  def delivery_params
    params.permit(:delivery_id)
  end

  def payment_params
    params.permit({ payment_attributes: [:name, :cvv, :expire, :card_number] })
  end

  def order_params
    params.permit(:id, :items, :total_price, :coupon, :delivery_id, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { paymnet_attributes: [:name, :cvv, :expire, :card_number] }).merge(customer: current_customer)
  end
end
