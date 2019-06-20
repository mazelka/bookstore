require 'spec_helper'
require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'associations' do
    it { should have_many(:reviews) }
  end

  context 'validations' do
    it 'is invalid without a first_name' do
      expect((FactoryBot.build :customer, first_name: nil)).not_to be_valid
    end

    it 'is invalid with a first_name more than 50 characters' do
      expect((FactoryBot.build :customer, first_name: FFaker::String.from_regexp(/\A[a-zA-Z]{51}\z/))).not_to be_valid
    end

    it 'is invalid without a last_name' do
      expect((FactoryBot.build :customer, last_name: nil)).not_to be_valid
    end

    it 'is invalid with a first_name more than 50 characters' do
      expect((FactoryBot.build :customer, last_name: FFaker::String.from_regexp(/\A[a-zA-Z]{51}\z/))).not_to be_valid
    end

    it 'is invalid without an email' do
      expect((FactoryBot.build :customer, email: nil)).not_to be_valid
    end

    it 'is invalid with not valid email' do
      expect((FactoryBot.build :customer, email: 'notvalidemail')).not_to be_valid
    end

    it 'has unique email' do
      FactoryBot.create(:customer, email: 'email@unique.com') 
      expect((FactoryBot.build :customer, email: 'email@unique.com')).not_to be_valid
    end

    it 'is invalid with email more than 63 characters' do
      expect((FactoryBot.build :customer, email: "#{FFaker::String.from_regexp(/\A[a-zA-Z0-9]{55}\z/)}@mail.com")).not_to be_valid
    end

    it 'downacases email before save' do
      FactoryBot.create :customer, email: 'CAPITAL@EMAIL.com'
      expect((FactoryBot.build :customer, email: 'capital@email.com')).not_to be_valid
    end

    it 'is invalid without a password' do
      expect((FactoryBot.build :customer, password: nil)).not_to be_valid
    end

    it 'is invalid with a password less than 8 symbols' do
      expect((FactoryBot.build :customer, password: '7Symbol')).not_to be_valid
    end

    it 'is invalid if password does not match validation rules' do
      expect((FactoryBot.build :customer, password: '7symbols')).not_to be_valid
      expect((FactoryBot.build :customer, password: '7SYMBOLS')).not_to be_valid
      expect((FactoryBot.build :customer, password: 'Symbolss')).not_to be_valid
      expect((FactoryBot.build :customer, password: '123123123')).not_to be_valid
      expect((FactoryBot.build :customer, password: '7Sym bols')).not_to be_valid
    end
  end
end
