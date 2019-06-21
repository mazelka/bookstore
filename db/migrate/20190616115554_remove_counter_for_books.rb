class RemoveCounterForBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :books_counter
  end
end
