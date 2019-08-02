require 'sidekiq-scheduler'

class OrderReminder
  include Sidekiq::Worker

  def perform
    day_before_yesterday = Time.zone.now - 48.hour
    yesterday = Time.zone.now - 24.hour
    Order.where(aasm_state: 'in_progress', updated_at: day_before_yesterday..yesterday).each do |order|
      ApplicationMailer.order_reminder(order.customer).deliver
    end
  end
end
