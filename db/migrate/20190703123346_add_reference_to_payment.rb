class AddReferenceToPayment < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.references :payment
    end
  end
end
