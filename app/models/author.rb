class Author < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z]+\z/ }
end
