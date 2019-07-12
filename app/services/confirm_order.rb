class ConfirmOrder
  def initialize(order)
    @order = order
  end

  def order
    @order
  end

  def order_can_be_started?
    order.delivery.present? && order.payment.present? && order.shipping_address.present? && order.billing_address.present? && order.order_items.present?
  end

  def confirm
    if order_can_be_started?
      order.start_processing!
    else
      order.errors.add(:base, I18n.t('common.error_missed_info'))
    end
  end
end
