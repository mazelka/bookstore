class AddDiscardedAtToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :discarded_at, :datetime
    add_index :authors, :discarded_at
  end
end
