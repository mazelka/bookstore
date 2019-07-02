class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :name
      t.integer :days
      t.float :price

      t.timestamps
    end

    add_column :orders, :delivery, :string
  end
end
