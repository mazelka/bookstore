class OrderItemsController < ApplicationController
  private

  def order_items_params
    params.require(:order_items).permit(:id, :book, :quantity)
  end
end
