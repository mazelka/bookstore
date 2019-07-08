class SettingsController < ApplicationController
  def update
    if current_customer.update(customer_params)
      flash[:notice] = 'Your settings updated!'
      sign_in(:customer, current_customer)
    end
    render 'index'
  end

  def customer_params
    params.require(:customer).permit(:email, :password, :first_name, :last_name, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end
end
