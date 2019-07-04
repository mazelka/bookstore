class UpdateOrderPayment
  def initialize(order, params)
    @order = order
    @params = params
  end

  def order
    @order
  end

  def params
    @params
  end

  def update
    order.update(params)
  end
end
