require 'sidekiq-scheduler'

class OrderReminder
  include Sidekiq::Worker

  def perform
    Customer.all.map do |customer|
      next unless customer.orders.last.present?

      if in_progress?(customer.orders.last)
        ApplicationMailer.order_reminder(customer).deliver
      end
    end
  end

  def in_progress?(order)
    order.aasm_state == 'in_progress' && (Time.zone.now - order.updated_at) > 24.hours && (Time.zone.now - order.updated_at) < 48.hours
  end
end
