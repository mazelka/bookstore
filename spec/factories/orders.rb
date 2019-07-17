FactoryBot.define do
  factory :order do
    coupon
    customer
    total_price { Random.rand(40) }

    trait :without_address do
      after(:create) do |order, _evaluator|
        3.times do
          order.order_items << build(:order_item)
        end
      end
    end

    trait :complete do
      aasm_state { 'in_queue' }
      delivery
      after(:create) do |order, _evaluator|
        3.times do
          order.order_items << build(:order_item)
        end
        shipping_address = build(:address, :shipping_address)
        binding.pry unless shipping_address.valid?

        order.shipping_address = shipping_address
        order.billing_address = order.shipping_address
        order.payment = build(:payment)
      end
    end
  end

  trait :with_customer do
  end
end
