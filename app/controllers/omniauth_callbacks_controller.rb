class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    customer = Customer.from_omniauth(request.env['omniauth.auth'])
    if customer.persisted?
      sign_in_and_redirect customer
      flash.notice = 'Successfully signed in!'
    else
      session['devise.customer_attributes'] = customer.attributes
      redirect_to new_customer_registration_path
    end
  end
end
