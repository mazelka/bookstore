FactoryBot.define do
  factory :coupon do
    name { FFaker::Color.name }
    discount { Random.rand(40) }
  end
end
