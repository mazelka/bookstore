class Order < ApplicationRecord
  has_many :order_items
  belongs_to :customer

  validates :total_price, presence: true
end
