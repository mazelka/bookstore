class SettingsController < ApplicationController
  def index
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      flash[:notice] = 'Your settings updated!'
      sign_in(:customer, @customer)
    end
    render 'index'
  end

  def update_email
    current_user.update(params[:user])
  end

  def customer_params
    params.require(:customer).permit(:email, :password, :first_name, :last_name, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end
end
