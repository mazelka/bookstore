class RenameCounterCacheBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :jobs_count, :books_counter
  end
end
