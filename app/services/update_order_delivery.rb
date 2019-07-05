class UpdateOrderDelivery
  def initialize(order, params)
    @params = params
    @order = order
  end

  def order
    @order
  end

  def params
    @params
  end

  def update
    binding.pry
    order.update({ delivery: Delivery.find(params[:delivery_id]) })
  end
end
