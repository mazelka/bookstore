class OrdersController < ApplicationController
  private

  def order_params
    params.require(:order).permit(:id, :items, :total_price)
  end
end
