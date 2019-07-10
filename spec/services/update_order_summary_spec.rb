require 'rails_helper'

RSpec.describe UpdateOrderSummary, type: :model do
  let(:order) { create(:order, :complete) }
  let(:book) { create(:book) }
  let(:cart) { [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }] }
  let(:coupon) { 100 }
  let(:cart_details) { CartDetails.new(cart, coupon) }
  let(:summary_service) { UpdateOrderSummary.new(order, cart_details) }

  before :each do
    summary_service
  end
  it 'has order' do
    expect(summary_service.order).to eq(order)
  end

  it 'calculates total' do
    total = cart_details.raw_subtotal - cart_details.raw_coupon + order.delivery.price
    expect(summary_service.calculate_total).to eq(total)
  end

  it 'has params for update total' do
    expect(summary_service.total).to eq(total_price: summary_service.calculate_total)
  end

  it 'updates order summary' do
    summary_service.update
    expect(order.total_price).to eq(summary_service.calculate_total)
  end
end
