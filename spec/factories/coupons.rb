FactoryBot.define do
  factory :coupon do
    name { FFaker::Lorem.characters.slice(0, 40) }
    discount { Random.rand(40) }
  end
end
