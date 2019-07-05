class UpdateOrderSummary
  def initialize(order, cart_details)
    @order = order
    @cart_details = cart_details
  end

  def order
    @order
  end

  def calculate_total
    @cart_details.raw_subtotal - @cart_details.raw_coupon + order.delivery.price
  end

  def total
    { total_price: calculate_total }
  end

  def update
    order.update(total)
  end
end
