class Book < ApplicationRecord
  belongs_to :author
  belongs_to :category
  # has_many :ratings

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :count, presence: true
end
