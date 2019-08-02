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
        order.shipping_address = build(:address, :shipping_address)
        order.billing_address = order.shipping_address
        order.payment = build(:payment)
      end
    end
  end

  trait :with_customer do
  end

  trait :updated_at do
    updated_at { Time.zone.now - 25.hours }
  end
end
