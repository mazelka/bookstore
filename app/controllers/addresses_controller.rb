class AddressesController < ApplicationController
  # def create
  #   p params
  #   @address = Address.new
  #   @address.attributes = params
  #   @address.errors unless @address.save
  # end

  private

  def address_params
    params.permit(:id, :address_line, :country, :city, :zip, :phone)
  end
end
