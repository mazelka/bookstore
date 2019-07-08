class Author < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }
  has_many :books, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z]+\z/ }

  after_discard do
    books.discard_all
  end
end
