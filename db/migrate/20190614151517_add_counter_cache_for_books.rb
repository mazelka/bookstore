class AddCounterCacheForBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :jobs_count, :integer, default: 0
  end
end
