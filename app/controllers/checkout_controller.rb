class CheckoutController < ApplicationController
  include Wicked::Wizard
  wrap_parameters :order, include: [:shipping_address_attributes, :billing_address_attributes]

  before_action :login_customer, :current_order
  steps :address, :delivery, :payment, :confirmation, :complete

  def show
    cart_details
    case step
    when :address
      prepopulate_addresses
    when :delivery
      @delivery = Delivery.all
    when :complete
      empty_session
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
      @order.errors.add(:base, t('checkout.errors.invalid_order'))
    end
    unless OrderSteps.new(@order).validate_properties(step)
      @order.errors.add(:base, t('checkout.errors.missed_information'))
    end
    render_wizard(@order)
  end

  def customer_has_address?
    current_customer.shipping_address.present?
  end

  def order_has_address?
    @order.shipping_address
  end

  def prepopulate_addresses
    if customer_has_address? && !order_has_address?
      @order.build_shipping_address(current_customer.shipping_address.address_params)
    end
  end

  def current_order
    if session[:order_id].nil?
      redirect_to carts_path
    else
      @order = Order.find(session[:order_id])
    end
  end

  def cart_details
    @coupon = session[:coupon_id] ? Coupon.find(session[:coupon_id]).discount : 0
    @cart = find_cart
    @cart_details = CartDetails.new(@cart, @coupon)
  end

  def finish_wizard_path
    root_path
  end

  def empty_session
    session.delete(:cart)
    session.delete(:coupon)
    session.delete(:coupon_id)
    session.delete(:order_id)
  end

  def login_customer
    redirect_to quick_registrations_path unless customer_signed_in?
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
