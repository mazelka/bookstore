
class Book < ApplicationRecord
  belongs_to :author
  belongs_to :category
  has_many :reviews
  mount_uploader :cover, CoverUploader

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :count, presence: true
end
