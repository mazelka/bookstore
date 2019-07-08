class RenameColumnAddress < ActiveRecord::Migration[5.2]
  def change
    rename_column :addresses, :address, :address_line
  end
end
