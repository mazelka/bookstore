class RemoveConfirmationForAdmins < ActiveRecord::Migration[5.2]
  def change
    remove_column :admin_users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_column :admin_users, :unconfirmed_email
  end
end
