class CheckoutController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_customer!
  steps :address, :delivery, :payment, :confirmation, :complete

  def show
    @addresses = current_customer.addresses || []
    render_wizard
  end

  def update
    @order = Order.new
    p address_params
    @address = Address.create(address_params)
    @order.shipping_address = @address
    render 'delivery'
  end

  def customer_has_address?
    current_customer.addresses.exists?
  end

  def new
    session[:order_params] ||= {}
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
  end

  def __create
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
    if @order.valid?
      if params[:back_button]
        @order.previous_step
      elsif @order.last_step?
        @order.save if @order.all_valid?
      else
        @order.next_step
      end
      session[:order_step] = @order.current_step
    end
    if @order.new_record?
      render 'new'
    else
      session[:order_step] = session[:order_params] = nil
      flash[:notice] = 'Order saved!'
      redirect_to @order
    end
  end

  def address_params
    params.require(:address).permit(:id, :address, :country, :city, :zip, :phone)
  end
end
