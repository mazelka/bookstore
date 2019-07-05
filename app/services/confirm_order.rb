class ConfirmOrder
  def initialize(order)
    @order = order
  end

  def order
    @order
  end

  def order_has_all_attributes?
    order.attributes.each do |attr|
      return false if order[attr].nil?
    end
  end

  def confirm
    if order_has_all_attributes?
      order.start_prcessing!
    else
      p 'error'
    end
  end
end
