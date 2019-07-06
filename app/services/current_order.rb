class CurrentOrder
  def initialize(order_id, cart, coupon_id)
    @cart = cart
    @coupon_id = coupon_id
    @order_id = order_id
    binding.pry

    @order = find_order
  end

  def find_order
    if @order_id.nil?
      @order = create_order_with_items
    else
      @order = Order.find(@order_id)
    end
  end

  def create_order_with_items
    if @cart.nil?
      redirect_to cart_path
    else
      @order = Order.create(customer: current_customer, coupon: find_coupon)
      add_items_from_cart
      @order
    end
  end

  def add_items_from_cart
    @cart.map do |item|
      create_item(item[:book_id], item[:quantity])
    end
  end

  def create_item(book_id, quantity)
    item = OrderItem.new(book: Book.find(book_id), quantity: quantity, order: @order)
    item.save
  end

  def find_coupon
    @coupon_id.nil? ? nil : Coupon.find(@coupon_id)
  end
end
