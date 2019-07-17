FactoryBot.define do
  factory :order_item do
    order
    book
    quantity { Random.rand(10) }
  end
end
