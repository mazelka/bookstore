class CustomersController < ApplicationController
  def destroy
    current_customer.discard
    Devise.sign_out_all_scopes ? sign_out : sign_out(current_customer)
    flash[:message] = 'Your account was deleted.'
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:email, :password, :first_name, :last_name, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end
end
