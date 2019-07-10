class AddDiscardedAtToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :discarded_at, :datetime
    add_index :customers, :discarded_at
  end
end
