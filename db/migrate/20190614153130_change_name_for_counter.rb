class ChangeNameForCounter < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :jobs_count, :books_counter
  end
end
