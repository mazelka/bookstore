FactoryBot.define do
  factory :review do
    customer
    book
    title { FFaker::String.from_regexp(/\A[a-zA-Z0-9]{70}\z/) }
    text { FFaker::String.from_regexp(/\A[a-zA-Z0-9]{200}\z/) }
  end
end
