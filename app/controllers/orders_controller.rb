class OrdersController < ApplicationController
  def coupon
    @coupon = session[:coupon] || 0
  end

  def total_price
    session[:cart].map { |item| item[:price] * item[:quantity] }.sum - coupon
  end

  def sub_total
    total_price - coupon
  end

  private

  def order_params
    params.permit(:id, :items, :total_price, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] }).merge(customer: current_customer)
  end

  def create_item(book_id, quantity)
    item = OrderItem.new(book: Book.find(book_id), quantity: quantity, order: @order)
    item.save
  end
end
