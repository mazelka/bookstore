class UpdateOrderDelivery
  attr_reader :order, :params

  def initialize(order, params)
    @params = params
    @order = order
  end

  def update
    order.update({ delivery: Delivery.find(params[:delivery_id]) })
  end
end
