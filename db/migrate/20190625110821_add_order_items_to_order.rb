class AddOrderItemsToOrder < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.references :customer, foreign_key: true
    end
  end
end
