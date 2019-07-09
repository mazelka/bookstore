FactoryBot.define do
  factory :address do
    address_line { FFaker::AddressUS.street_address }
    country { FFaker::AddressUS.country }
    city { FFaker::AddressUS.city }
    zip { FFaker::AddressUS.zip_code }
    phone { FFaker::PhoneNumberAU.international_mobile_phone_number }
    addressable_type { 'Customer' }
    addressable_id { create(:customer).id }
  end

  # factory :shipping_address do
  #   association :addressable, factory: :address
  #   address { 'MyString' }
  #   country { 'MyString' }
  #   city { 'MyString' }
  #   zip { 'MyString' }
  #   phone { 'MyString' }
  #   addressable { 'Order' }
  # end

  # factory :billing_address do
  #   association :addressable, factory: :address
  #   address { 'MyString' }
  #   country { 'MyString' }
  #   city { 'MyString' }
  #   zip { 'MyString' }
  #   phone { 'MyString' }
  #   addressable { 'Order' }
  # end
end
