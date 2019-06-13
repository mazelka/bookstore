class MovePriceBackToFloat2 < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :price, :float
  end
end
