FactoryBot.define do
  factory :delivery do
    name { FFaker::AnimalUS.common_name }
    days { Random.rand(40) }
    price { Random.rand(40) }
  end
end
