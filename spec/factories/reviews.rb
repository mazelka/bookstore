FactoryBot.define do
  factory :review do
    customer
    book
    title { FFaker::Lorem.characters.gsub(/[0-9]/, '').slice(0, 70) }
    text { FFaker::Lorem.characters.gsub(/[0-9]/, '').slice(0, 200) }
    aasm_state { 'unprocessed' }
  end
end
