FactoryBot.define do
  factory :payment do
    card_number { "MyString" }
    cvv { "MyString" }
    name { "MyString" }
    expire { "MyString" }
    order { nil }
  end
end
