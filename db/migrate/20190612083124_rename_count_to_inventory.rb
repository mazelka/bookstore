class RenameCountToInventory < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :count, :inventory
  end
end
