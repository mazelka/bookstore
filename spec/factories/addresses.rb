FactoryBot.define do
  factory :address do
    address_line { FFaker::AddressUS.street_address }
    country { %w[Ukraine USA Poland Germany].sample }
    city { FFaker::AddressUS.city }
    zip { FFaker::AddressUS.zip_code }
    phone { FFaker::PhoneNumberAU.international_mobile_phone_number }
  end

  trait :customer_address do
    association :addressable, factory: :customer
  end
  trait :shipping_address do
    association :addressable, factory: :order
  end
  trait :billing_address do
    association :addressable, factory: :order
  end
end
