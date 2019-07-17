require 'rails_helper'

RSpec.describe Delivery, type: :model do
  context 'validations' do
    it 'is invalid without a name' do
      expect((build :delivery, name: nil)).not_to be_valid
    end

    it 'is invalid without a days' do
      expect((build :delivery, days: nil)).not_to be_valid
    end

    it 'is invalid without a price' do
      expect((build :delivery, price: nil)).not_to be_valid
    end

    it 'is invalid with a non numerical price' do
      expect((build :delivery, price: 'asdf')).not_to be_valid
      expect((build :delivery, price: '123 123')).not_to be_valid
    end
  end
end
