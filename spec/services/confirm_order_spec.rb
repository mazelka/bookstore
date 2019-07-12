require 'rails_helper'

RSpec.describe ConfirmOrder do
  context 'complete order' do
    let(:order) { create(:order, :complete, aasm_state: 'in_progress') }

    it 'has order' do
      expect(ConfirmOrder.new(order).order).to eq(order)
    end

    it 'validates order for required parameters' do
      expect(ConfirmOrder.new(order).order_can_be_started?).to be true
    end

    it 'starts processing valid order' do
      ConfirmOrder.new(order).confirm
      expect(order.aasm_state).to eq('in_queue')
    end
  end

  context 'not complete order' do
    let(:order) { create(:order, :with_customer, total_price: nil) }

    it 'validates order attributes' do
      expect(ConfirmOrder.new(order).order_can_be_started?).to be false
    end

    it 'cannot start processing invalid order' do
      ConfirmOrder.new(order).confirm
      expect(order.errors.messages[:base]).to include('You missed to enter some info!')
    end
  end
end
