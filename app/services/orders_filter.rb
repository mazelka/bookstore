class OrdersFilter
  def self.call(current_customer, sorting)
    new.call(current_customer, sorting)
  end

  def call(current_customer, sorting)
    @orders = case sorting
              when I18n.t('orders.index.in_progress')
                current_customer.orders.in_progress
              when I18n.t('orders.index.in_delivery')
                current_customer.orders.in_delivery
              when I18n.t('orders.index.canceled')
                current_customer.orders.canceled
              else
                current_customer.orders
              end
  end
end
