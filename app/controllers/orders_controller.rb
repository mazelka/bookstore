class OrdersController < ApplicationController
  def create
    @order = Order.new(customer: current_customer, total_price: total_price, coupon: coupon)
    if @order.save
      items_from_cart
      binding.pry
      render 'orders'
    else
      flash[:notice] = @order.errors.full_messages
      redirect_to cart_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:id, :items, :total_price)
  end

  def items_from_cart
    session[:cart].map do |item|
      create_item(item[:book_id], item[:quantity])
    end
  end

  def create_item(book_id, quantity)
    item = OrderItem.new(book: Book.find(book_id), quantity: quantity, order: @order)
    binding.pry
    item.save
  end

  def coupon
    @coupon = session[:coupon] || 0
  end

  def total_price
    session[:cart].map { |item| item[:price] * item[:quantity] }.sum - coupon
  end
end