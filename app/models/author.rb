class Author < ApplicationRecord
  has_many :books

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
end
