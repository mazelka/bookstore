class RemoveDeliveryColumnInOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :delivery
  end
end
