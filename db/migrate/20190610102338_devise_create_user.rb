class DeviseCreateUser < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :password_salt, :string
  end
end
