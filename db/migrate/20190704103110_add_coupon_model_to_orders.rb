class AddCouponModelToOrders < ActiveRecord::Migration[5.2]
  def change
    change_table :coupons do |t|
      t.references :order, foreign_key: true
    end
  end
end
