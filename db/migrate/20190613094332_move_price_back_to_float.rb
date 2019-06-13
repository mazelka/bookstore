class MovePriceBackToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :price, :float
  end
end
