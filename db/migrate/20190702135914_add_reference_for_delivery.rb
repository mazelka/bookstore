class AddReferenceForDelivery < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.references :delivery
    end
  end
end
