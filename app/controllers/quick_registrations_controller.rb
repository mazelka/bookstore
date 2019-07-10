class QuickRegistrationsController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def show_lazy_login
    @customer = Customer.new
    render 'login'
  end

  def lazy_sign_up
    if email_valid?(params[:customer][:email])
      generated_password = Devise.friendly_token.first(8)
      customer = Customer.new(email: params[:customer][:email], password: generated_password)
      customer.save(validate: false)
      sign_in(:customer, customer)
      redirect_to cart_path
      customer.send_reset_password_instructions
    else
      flash[:notice] = t('quick_registrations.login.invalid_email')
      redirect_to login_path
    end
  end

  def email_valid?(email)
    email.match(VALID_EMAIL_REGEX)
  end
end
