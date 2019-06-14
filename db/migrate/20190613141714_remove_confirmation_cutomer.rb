class RemoveConfirmationCutomer < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_column :customers, :unconfirmed_email
  end
end
