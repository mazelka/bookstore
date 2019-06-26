class OrdersController < ApplicationController
  attr_reader :items, :total_price

  private

  def order_params
    params.require(:order).permit(:id, :items, :total_price)
  end
end
