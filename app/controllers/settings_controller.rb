class SettingsController < ApplicationController
  wrap_parameters :customer

  def update
    if current_customer.update(customer_params)
      flash[:notice] = t('settings.index.updated')
      sign_in(:customer, current_customer)
    end
    redirect_to settings_path
  end

  def customer_params
    params.permit(:email, :password, :first_name, :last_name, { shipping_address_attributes: [:address_line, :country, :city, :zip, :phone] }, { billing_address_attributes: [:address_line, :country, :city, :zip, :phone] })
  end
end
