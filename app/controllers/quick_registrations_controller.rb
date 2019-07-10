class QuickRegistrationsController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def index
    @customer = Customer.new
  end

  def create
    if email_valid?(params[:customer][:email])
      generated_password = Devise.friendly_token.first(8)
      customer = Customer.new(email: params[:customer][:email], password: generated_password)
      customer.save(validate: false)
      sign_in(:customer, customer)
      redirect_to carts_path
      customer.send_reset_password_instructions
    else
      flash[:notice] = 'Your email is invalid'
    end
  end

  def email_valid?(email)
    !Customer.find_by(email: email).present? && email.match(VALID_EMAIL_REGEX)
  end
end
