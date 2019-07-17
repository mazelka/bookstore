require 'rails_helper'

RSpec.describe OrderSteps, type: :model do
  context 'validate present properties' do
    let(:order) { create(:order, :complete) }
    let(:order_steps_service) { OrderSteps.new(order) }

    before :each do
      order_steps_service
    end

    it 'has order' do
      expect(order_steps_service.order).to eq(order)
    end

    it 'has true if order has address' do
      expect(order_steps_service.validate_properties(:address)).to be true
    end

    it 'has true if order has delivery' do
      expect(order_steps_service.validate_properties(:delivery)).to be true
    end

    it 'has true if order has payment' do
      expect(order_steps_service.validate_properties(:payment)).to be true
    end
  end

  context 'validate missed properties' do
    let(:order) { create(:order) }
    let(:order_steps_service) { OrderSteps.new(order) }

    before :each do
      order_steps_service
    end

    it 'has false if order has address' do
      expect(order_steps_service.validate_properties(:address)).to be false
    end

    it 'has false if order has delivery' do
      expect(order_steps_service.validate_properties(:delivery)).to be false
    end

    it 'has false if order has payment' do
      expect(order_steps_service.validate_properties(:payment)).to be false
    end
  end
end
