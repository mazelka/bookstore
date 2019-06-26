class OrderItemsController < ApplicationController
  attr_reader :book, :quantity

  private

  def order_items_params
    params.require(:order_items).permit(:id, :book, :quantity)
  end
end
