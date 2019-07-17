require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'associations' do
    it { should belong_to(:order) }
  end

  context 'validations of presence' do
    it 'is invalid without a name' do
      expect((build :payment, name: nil)).not_to be_valid
    end

    it 'is invalid without an expire' do
      expect((build :payment, expire: nil)).not_to be_valid
    end

    it 'is invalid without a card_number' do
      expect((build :payment, card_number: nil)).not_to be_valid
    end
    it 'is invalid without a cvv' do
      expect((build :payment, cvv: nil)).not_to be_valid
    end
  end

  context 'validations of length' do
    it 'is invalid with a name length more than 50' do
      expect((build :payment, name: FFaker::Lorem.characters(51))).not_to be_valid
    end

    it 'is invalid with an expire length more than 5' do
      expect((build :payment, expire: '12/2026')).not_to be_valid
    end

    it 'is invalid with a card_number length more than 16' do
      expect((build :payment, card_number: '12341234123412341')).not_to be_valid
    end

    it 'is invalid with a cvv length not 3 or 4 ' do
      expect((build :payment, cvv: '12')).not_to be_valid
      expect((build :payment, cvv: '12345')).not_to be_valid
    end
  end

  context 'validations of format' do
    it 'it valid only with letters in name' do
      expect((build :payment, name: "Masha T567st\ Kasha")).not_to be_valid
    end

    it 'is invalid with an invalid expire' do
      expect((build :payment, expire: '12202')).not_to be_valid
      expect((build :payment, expire: '12-02')).not_to be_valid
      expect((build :payment, expire: '12 02')).not_to be_valid
      expect((build :payment, expire: '12\02')).not_to be_valid
    end

    it 'is valid with a card_number contained only digits' do
      expect((build :payment, card_number: 'a234123412341234')).not_to be_valid
      expect((build :payment, card_number: '123412341234123-1')).not_to be_valid
      expect((build :payment, card_number: '123412/4123412341')).not_to be_valid
      expect((build :payment, card_number: '1234123 123412341')).not_to be_valid
      expect((build :payment, card_number: '12341234[23412341')).not_to be_valid
    end

    it 'is valid with a cvv contained only digits' do
      expect((build :payment, cvv: 'qw')).not_to be_valid
      expect((build :payment, cvv: '12 3')).not_to be_valid
    end
  end
end
