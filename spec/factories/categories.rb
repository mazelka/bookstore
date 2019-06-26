FactoryBot.define do
  factory :category do
    title { FFaker::Lorem.characters.slice(0, 40) }
  end
end
