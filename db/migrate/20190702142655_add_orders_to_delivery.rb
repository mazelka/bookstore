class AddOrdersToDelivery < ActiveRecord::Migration[5.2]
  def change
    change_table :deliveries do |t|
      t.references :order, foreign_key: true
    end
  end
end
