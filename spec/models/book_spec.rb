require 'spec_helper'
require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'associations' do
    it { should have_many(:reviews) }
    it { should belong_to(:author) }
    it { should belong_to(:category) }
  end

  context 'validations' do
    it 'has valid cover image' do
      book = FactoryBot.create :book
      expect(book.cover_url).to include('2017-07-24_12.22.44.jpg')
    end
    it 'is invalid without a title' do
      expect((FactoryBot.build :book, title: nil)).not_to be_valid
    end

    it 'is invalid with a title more than 50 characters' do
      expect((FactoryBot.build :book, title: FFaker::String.from_regexp(/\A[a-zA-Z]{51}\z/))).not_to be_valid
    end

    it 'is invalid without a price' do
      expect((FactoryBot.build :book, price: nil)).not_to be_valid
    end

    it 'is invalid with a wrong format of price' do
      expect((FactoryBot.build :book, price: 'YTTREW')).not_to be_valid
    end

    it 'saves price as integer' do
      book = FactoryBot.create :book, price: 9.99
      expect(book.price).to eq(999)
    end

    it 'is invalid without an inventory' do
      expect((FactoryBot.build :book, inventory: nil)).not_to be_valid
    end

    it 'is invalid with a format of inventory as string' do
      expect((FactoryBot.build :book, inventory: 'YTTREW')).not_to be_valid
      expect((FactoryBot.build :book, inventory: 34.76)).not_to be_valid
    end

    it 'is invalid without an author' do
      expect((FactoryBot.build :book, author: nil)).not_to be_valid
    end

    it 'is invalid without a category' do
      expect((FactoryBot.build :book, category: nil)).not_to be_valid
    end
  end
end
