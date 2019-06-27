class CartDetails
  def initialize(cart, coupon = 0)
    @cart = cart
    @coupon = coupon
  end

  def subtotal
    @subtotal = @cart.each.map { |item| item[:price].to_f * item[:quantity] }.sum
    Money.new(@subtotal).format
  end

  def raw_coupon
    @coupon
  end

  def raw_subtotal
    @cart.each.map { |item| item[:price].to_f * item[:quantity] }.sum
  end

  def discount
    Money.new(@coupon).format
  end

  def total
    total = (raw_subtotal - raw_coupon).negative? ? 0 : (raw_subtotal - raw_coupon)
    Money.new(total).format
  end
end
