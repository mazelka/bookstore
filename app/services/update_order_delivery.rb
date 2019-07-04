class UpdateOrderDelivery
  def initialize(order, params)
    @order = order
    @params = params[:delivery_id]
  end

  def order
    @order
  end

  def params
    @params
  end

  def update
    order.update({ delivery: Delivery.find(params) })
  end
end
