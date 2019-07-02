class AddressesController < ApplicationController
  def create
    p params
    @address = Address.new
    @address.attributes = params
    @address.errors unless @address.save
  end

  private

  def address_params
    params.require(:address).permit(:id, :address, :country, :city, :zip, :phone)
  end
end
