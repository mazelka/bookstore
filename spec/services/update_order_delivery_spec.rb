require 'rails_helper'

RSpec.describe UpdateOrderDelivery, type: :model do
  let(:order) { create(:order) }
  let(:delivery) { create(:delivery) }
  let(:delivery_service) { UpdateOrderDelivery.new(order, delivery_id: delivery.id) }

  before :each do
    delivery_service
  end
  it 'has order' do
    expect(delivery_service.order).to eq(order)
  end

  it 'has params' do
    expect(delivery_service.params).to eq(delivery_id: delivery.id)
  end

  it 'updates order delivery' do
    delivery_service.update
    expect(order.delivery).to eq(delivery)
  end
end
