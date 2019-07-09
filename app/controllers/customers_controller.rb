class CustomersController < ApplicationController
  private

  def customer_params
    params.require(:customer).permit(:email, :password, :first_name, :last_name, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end
end
