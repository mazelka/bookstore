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
      order.start_processing!
    else
      order.errors.add(:base, 'You missed to enter some info!')
    end
  end
end
