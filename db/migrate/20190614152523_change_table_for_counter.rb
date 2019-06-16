class ChangeTableForCounter < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :books_count
    add_column :categories, :jobs_count, :integer, default: 0
  end
end
