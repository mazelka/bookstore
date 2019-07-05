class OrderSteps
  def initialize(order)
    @order = order
  end

  def order
    @order
  end

  def validate_properties(current_step)
    case current_step
    when :address
      order.shipping_address.present? && order.shipping_address.present?
    when :delivery
      order.delivery.present?
    when :payment
      order.payment.present?
    end
  end
end
