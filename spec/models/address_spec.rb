require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'associations' do
    it { should belong_to(:addressable) }
  end

  context 'validations of presence' do
    it 'is invalid without an address_line' do
      expect((build :address, :customer_address, address_line: nil)).not_to be_valid
    end

    it 'is invalid without a country' do
      expect((build :address, :customer_address, country: nil)).not_to be_valid
    end

    it 'is invalid without a city' do
      expect((build :address, :customer_address, city: nil)).not_to be_valid
    end

    it 'is invalid without a zip' do
      expect((build :address, :customer_address, zip: nil)).not_to be_valid
    end

    it 'is invalid without a phone' do
      expect((build :address, :customer_address, phone: nil)).not_to be_valid
    end
  end

  context 'validations of length' do
    it 'is invalid with an address_line length more than 50' do
      expect((build :address, :customer_address, address_line: FFaker::Lorem.characters(51))).not_to be_valid
    end

    it 'is invalid with a country length more than 50' do
      expect((build :address, :customer_address, country: FFaker::Lorem.characters(51))).not_to be_valid
    end

    it 'is invalid with a city length more than 50' do
      expect((build :address, :customer_address, city: FFaker::Lorem.characters(51))).not_to be_valid
    end

    it 'is invalid with a zip length more than 15' do
      expect((build :address, :customer_address, zip: Array.new(16) { 1 }.join)).not_to be_valid
    end

    it 'is invalid with a phone length more than 15' do
      expect((build :address, :customer_address, phone: "+#{Array.new(15) { 2 }.join}")).not_to be_valid
    end
  end

  context 'validations of format' do
    it 'address_line is invalid with special characters except - , ' do
      expect((build :address, :customer_address, address_line: '@asdgj')).not_to be_valid
      expect((build :address, :customer_address, address_line: '*&')).not_to be_valid
      expect((build :address, :customer_address, address_line: '< []')).not_to be_valid
    end

    it 'country is valid only with letters' do
      expect((build :address, :customer_address, country: '123 test')).not_to be_valid
      expect((build :address, :customer_address, country: '- @!#$ ')).not_to be_valid
      expect((build :address, :customer_address, country: 'New/America')).not_to be_valid
    end

    it 'city is valid only with letters' do
      expect((build :address, city: '123 test')).not_to be_valid
      expect((build :address, city: '- @!#$ ')).not_to be_valid
      expect((build :address, city: 'New-Year')).not_to be_valid
    end

    it 'zip is invalid with letters and spaces' do
      expect((build :address, zip: 'AS-12345')).not_to be_valid
      expect((build :address, zip: '12 2345')).not_to be_valid
    end

    it 'is invalid without a phone number format' do
      expect((build :address, phone: '123456789')).not_to be_valid
      expect((build :address, phone: '+1')).not_to be_valid
      expect((build :address, phone: '+112ASD')).not_to be_valid
      expect((build :address, phone: '  +1128745932')).not_to be_valid
    end
  end
end
