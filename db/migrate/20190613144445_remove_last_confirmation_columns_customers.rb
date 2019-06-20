class RemoveLastConfirmationColumnsCustomers < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :confirmed_at
    remove_column :customers, :confirmation_sent_at
  end
end
