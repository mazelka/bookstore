class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    customer = Customer.from_omniauth(request.env['omniauth.auth'])
    if customer.persisted?
      flash.notice = 'Successfully signed in!'
      sign_in_and_redirect customer
    else
      session['devise.customer_attributes'] = customer.attributes
      redirect_to new_customer_registration_path
    end
  end
end
