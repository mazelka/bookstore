class QuickRegsController < ApplicationController
  def show_lazy_login
    @customer = Customer.new
    render 'login'
  end

  def lazy_sign_up
    generated_password = Devise.friendly_token.first(8)
    customer = Customer.new(email: params[:customer][:email], password: generated_password)
    customer.save(validate: false)
    sign_in(:customer, customer)
    redirect_to cart_path
    Devise::Mailer.reset_password_instructions(customer, generated_password)
  end
end
