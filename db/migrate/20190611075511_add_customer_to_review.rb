class AddCustomerToReview < ActiveRecord::Migration[5.2]
  def change
    change_table :reviews do |t|
      t.references :customer, foreign_key: true
    end
  end
end
