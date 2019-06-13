class Review < ApplicationRecord
  belongs_to :book
  belongs_to :customer
  VALID_STRING_REGEX = /[a-zA-Z0-9!#$%&'*+-\/=?^_`{|}~]/

  validates :title, presence: true, length: { minimum: 1, maximum: 80 }, format: { with: VALID_STRING_REGEX }
  validates :text, presence: true, length: { minimum: 1, maximum: 500 }, format: { with: VALID_STRING_REGEX }
end
