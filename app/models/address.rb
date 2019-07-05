class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, optional: true

  validates :address_line, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z0-9 ,-]/ }
  validates :country, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :city, presence: true, length: { maximum: 50 }, format: { with: /[a-zA-Z]/ }
  validates :zip, presence: true, length: { maximum: 15 }, format: { with: /[0-9-]/ }

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
