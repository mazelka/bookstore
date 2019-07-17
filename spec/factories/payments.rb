FactoryBot.define do
  factory :payment do
    order
    card_number { '4111411141114111' }
    cvv { [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].sample(3).join }
    name { FFaker::Name.name }
    expire { '06/26' }
  end
end
