class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :country
      t.string :city
      t.string :zip
      t.string :phone
      t.references :addressable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
