FactoryBot.define do
  factory :customer do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password { '123qweASD' }
  end

  trait :with_addresses do
    shipping_address { build(:address, :customer_address) }
  end
end
