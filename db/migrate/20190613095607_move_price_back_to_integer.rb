class MovePriceBackToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :price, :integer
  end
end
