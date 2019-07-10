require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:order) }
  end

  context 'validations' do
    it 'is invalid without quantity' do
      expect((build :order_item, quantity: nil)).not_to be_valid
    end

    it 'is invalid with not numerical quantity' do
      expect((build :order_item, quantity: 'not numerical')).not_to be_valid
    end

    it 'is invalid with not positive quantity' do
      expect((build :order_item, quantity: 0)).not_to be_valid
    end
  end
end
