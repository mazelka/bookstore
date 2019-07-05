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
    order.update({ delivery: Delivery.find(params[:delivery_id]) })
  end
end
