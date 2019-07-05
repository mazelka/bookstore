class CheckoutController < ApplicationController
  include Wicked::Wizard

  before_action :find_order
  steps :address, :delivery, :payment, :confirmation, :complete

  def show
    cart_details
    case step
    when :address
      prepopulate_addresses
    when :delivery
      @delivery = Delivery.all
    end
    render_wizard
  end

  def update
    cart_details
    case step
    when :address
      UpdateOrderAddress.new(@order, address_params).update
    when :delivery
      UpdateOrderDelivery.new(@order, delivery_params).update
      UpdateOrderSummary.new(@order, cart_details).update
    when :payment
      UpdateOrderPayment.new(@order, payment_params).update
    when :confirmation
      ConfirmOrder.new(@order).confirm
    else
      @order.errors.add(:base, 'Order is invalid')
    end
    unless OrderSteps.new(@order).validate_properties(step)
      @order.errors.add(:base, 'You missed information for current step!')
    end
    render_wizard(@order)
  end

  def customer_has_address?
    current_customer.address
  end

  def order_has_address?
    @order.shipping_address
  end

  def prepopulate_addresses
    if customer_has_address? && !order_has_address?
      @order.build_shipping_address(current_customer.address.last.address_params)
    end
  end

  def find_order
    if session[:order_id].nil?
      @order = create_order_with_items
    else
      @order = Order.find(session[:order_id])
    end
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

  def cart_details
    @coupon = session[:coupon_id] ? Coupon.find(session[:coupon_id]).discount : 0
    @cart = find_cart
    @cart_details = CartDetails.new(@cart, @coupon)
  end

  def finish_wizard_path
    session.delete(:cart)
    session.delete(:coupon)
    session.delete(:coupon_id)
    session.delete(:order_id)
    root_path
  end

  def find_coupon
    session[:coupon_id].nil? ? nil : Coupon.find(session[:coupon_id])
  end

  def add_items_from_cart
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
    params.permit({ payment_attributes: [:id, :name, :cvv, :expire, :card_number] })
  end

  def order_params
    params.permit(:total_price, :delivery_id, :coupon, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { paymnet_attributes: [:id, :name, :cvv, :expire, :card_number] }).merge(customer: current_customer)
  end
end
