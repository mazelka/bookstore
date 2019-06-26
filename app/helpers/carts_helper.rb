module CartsHelper
  def cart_subtotal(cart)
    @subtotal = cart.each.map { |item| item[:price].to_f * item[:quantity] }.sum
    Money.new(@subtotal, 'USD').format
  end

  def discount(coupon)
    @coupon = coupon
    Money.new(@coupon, 'USD').format
  end

  def total
    Money.new(@subtotal - @coupon).format
  end
end
