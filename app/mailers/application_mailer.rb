class ApplicationMailer < ActionMailer::Base
  default from: 'mary@test.com'
  layout 'mailer'

  def order_confirmation(customer, order)
    @email = customer.email
    @order = order.id
    mail to: customer.email, subject: 'Order Confirmation'
  end

  def order_reminder(customer)
    @email = customer.email
    mail to: customer.email, subject: 'Your Order Misses You'
  end
end
