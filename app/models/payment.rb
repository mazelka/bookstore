class Payment < ApplicationRecord
  belongs_to :order

  validates :name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z -]/ }
  validates :expire, presence: true, length: { maximum: 5 }, format: { with: /\A[01][0-9]\/[0-3][0-9]\z/ }
  validates :cvv, presence: true, length: { minimum: 3, maximum: 4 }, format: { with: /[0-9]/ }
  validates :card_number, presence: true, length: { maximum: 16 }, format: { with: /\A[0-9]{12}/ }
end
