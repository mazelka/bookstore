class Book < ApplicationRecord
  include Discard::Model
  before_save :normalize_price
  default_scope -> { kept }

  belongs_to :author
  belongs_to :category
  has_many :reviews
  mount_uploader :cover, CoverUploader

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: true
  validates :inventory, presence: true, numericality: { only_integer: true }

  scope :latest, -> { kept.order(created_at: :asc).last(3) }
  scope :kept, -> { undiscarded.joins(:author).merge(Author.kept) }

  def normalize_price
    self.price = price * 100
  end
end
