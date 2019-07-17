require 'rails_helper'

RSpec.describe UpdateOrderAddress, type: :model do
  let(:order) { create(:order, :without_address) }
  let(:shipping_params) { create(:address, :shipping_address) }
  let(:billing_params) { create(:address, :shipping_address) }
  it 'has order' do
    address_service = UpdateOrderAddress.new(order, shipping_address: shipping_params)
    expect(address_service.order).to eq(order)
  end

  it 'has params' do
    address_service = UpdateOrderAddress.new(order, shipping_address: shipping_params)
    expect(address_service.params).to eq(shipping_address: shipping_params)
  end

  it 'updates order address' do
    address_service = UpdateOrderAddress.new(order, shipping_address: shipping_params, billing_address: billing_params)
    address_service.update
    expect(order.shipping_address).to eq(shipping_params)
    expect(order.billing_address).to eq(billing_params)
  end
end
