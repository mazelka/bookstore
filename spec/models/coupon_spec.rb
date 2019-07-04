require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'validations' do
    let(:coupon) { create :coupon }

    it 'is invalid without name' do
      expect((build :coupon, name: nil)).not_to be_valid
    end

    it 'is invalid without discount' do
      expect((build :coupon, discount: nil)).not_to be_valid
    end

    it 'is invalid with not unique name' do
      coupon = build(:coupon)
      expect(coupon).to validate_uniqueness_of(:name).case_insensitive
    end
  end
end
