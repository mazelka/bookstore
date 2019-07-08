class UpdateOrderPayment
  attr_reader :order, :params

  def initialize(order, params)
    @order = order
    @params = params
  end

  def update
    order.update(params)
  end
end
