require 'rails_helper'

RSpec.describe UpdateOrderPayment, type: :model do
  let(:order) { create(:order) }
  let(:payment) { build(:payment) }
  let(:payment_service) { UpdateOrderPayment.new(order, payment: payment) }

  before :each do
    payment_service
  end
  it 'has order' do
    expect(payment_service.order).to eq(order)
  end

  it 'has params' do
    expect(payment_service.params).to eq(payment: payment)
  end

  it 'updates order payment' do
    payment_service.update
    expect(order.payment).to eq(payment)
  end
end
