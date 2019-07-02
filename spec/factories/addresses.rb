FactoryBot.define do
  factory :address do
    address { "MyString" }
    country { "MyString" }
    city { "MyString" }
    zip { "MyString" }
    phone { "MyString" }
    addressable { nil }
  end
end
