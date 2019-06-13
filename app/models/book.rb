class Book < ApplicationRecord
  before_save :normalize_price

  belongs_to :author
  belongs_to :category
  has_many :reviews
  mount_uploader :cover, CoverUploader

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: true
  validates :inventory, presence: true, numericality: { only_integer: true }

  def normalize_price
    self.price = price * 100
  end
end
