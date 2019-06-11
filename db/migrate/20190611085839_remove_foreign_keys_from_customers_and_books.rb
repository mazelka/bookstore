class RemoveForeignKeysFromCustomersAndBooks < ActiveRecord::Migration[5.2]
  def change
    remove_reference :books, :review, index: true, foreign_key: true
    remove_reference :customers, :review, index: true, foreign_key: true
  end
end
