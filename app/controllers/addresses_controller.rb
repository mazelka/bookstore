class AddressesController < ApplicationController
  private

  def address_params
    params.permit(:id, :address_line, :country, :city, :zip, :phone)
  end
end
