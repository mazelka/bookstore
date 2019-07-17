class Coupon < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :discount, presence: true
end
