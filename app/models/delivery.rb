class Delivery < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :days, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
end
