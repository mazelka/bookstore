class OrderSteps
  attr_writer :current_step

  def initialize(order)
    @order = order
  end

  def order
    @order
  end

  def current_step
    order.current_step || steps.first
  end

  def steps
    %w[address delivery payment confirmation complete]
  end

  def next_step
    order.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    order.current_step = steps[steps.index(current_step) - 1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def validate_properties(current_step)
    case current_step
    when :address
      order.shipping_address.nil? && order.shipping_address.nil?
    when :delivery
      order.delivery.nil?
    when :payment
      order.payment.nil?
    else
      p 'ok'
    end
  end
end
