require 'sidekiq-scheduler'

class OrderReminder
  include Sidekiq::Worker

  def perform
    Customer.all.map do |customer|
      if customer.orders.last.present?
        unless in_progress?(customer.orders.last)
          ApplicationMailer.order_reminder(customer).deliver
        end
      end
    end
  end

  def in_progress?(order)
    order.aasm_state == 'in_progerss' && (Time.now - order.updated_at) > 24.hours && (Time.now - order.updated_at) < 48.hours
  end
end
