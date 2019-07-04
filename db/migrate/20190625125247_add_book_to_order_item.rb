class AddBookToOrderItem < ActiveRecord::Migration[5.2]
  def change
    change_table :order_items do |t|
      t.references :book, foreign_key: true
    end
  end
end
