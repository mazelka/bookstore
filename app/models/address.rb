class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :address_line, presence: true, length: { maximum: 50 }, format: { with:  /\A\d+\s\D+\s\D+\z/ }
  validates :country, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z ,'()-]+\z/ }
  validates :city, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z ']+\z/ }
  validates :zip, presence: true, length: { maximum: 15 }, format: { with: /\A[\d -]+\z/ }
  validates :phone, presence: true, length: { maximum: 15 }, format: { with: /\+{1}[0-9]{2,}/ }

  def address_params
    {
      address_line: address_line,
      country: country,
      city: city,
      zip: zip,
      phone: phone,
    }
  end
end
