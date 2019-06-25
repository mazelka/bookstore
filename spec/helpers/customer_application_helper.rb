require 'rails_helper'

module Authentication
  def customer_sign_in
    create(:customer)
    visit '/customers/sign_in'
    page.find('#email').set(customer.email)
    page.find('#password').set(customer.password)
    page.find('#submit').click
  end
end