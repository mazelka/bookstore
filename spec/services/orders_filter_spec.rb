require 'rails_helper'

RSpec.describe OrdersFilter, type: :model do
  let!(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:in_queue_order) { create(:order, :with_customer, customer: customer, aasm_state: 'in_queue') }
  let!(:in_delivery_order) { create(:order, :with_customer, customer: customer, aasm_state: 'in_delivery') }
  let!(:delivered_order) { create(:order, :with_customer, customer: customer, aasm_state: 'delivered') }
  let!(:canceled_order) { create(:order, :with_customer, customer: customer, aasm_state: 'canceled') }
  let!(:other_order) { create(:order, :with_customer, customer: other_customer, aasm_state: 'in_queue') }

  it 'sorts by in_progress status' do
    expect(OrdersFilter.call(customer, 'In Progress')).to match_array(customer.orders.in_progress)
  end

  it 'sorts by in_delivery status' do
    expect(OrdersFilter.call(customer, 'In Delivery')).to match_array(customer.orders.in_delivery)
  end

  it 'sorts by canceled status' do
    expect(OrdersFilter.call(customer, 'Canceled')).to match_array(customer.orders.canceled)
  end

  it 'shows all orders' do
    expect(OrdersFilter.call(customer, 'some string')).to match_array(customer.orders.all)
  end
end
