class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :discount, presence: true
end
