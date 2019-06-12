require 'spec_helper'
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:inventory) }
  it { should validate_length_of(:title) }
  it { should validate_numericality_of(:inventory) }
  it { should validate_numericality_of(:price) }
  it { should have_many(:reviews) }
  it { should belong_to(:author) }
  it { should belong_to(:category) }

  context 'associations' do
    book = FactoryBot.create(:book)

    it 'belongs to category' do
      expect(book).to respond_to :category
    end

    it 'belongs to author' do
      expect(book).to respond_to :author
    end

    it 'has many reviews' do
      expect(book).to respond_to :reviews
    end
  end

  context 'validations' do
    it 'has valid cover image' do
      book = FactoryBot.create :book
      expect(book.cover_url).to eq('/uploads/book/cover/1/2017-07-24_12.22.44.jpg')
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

    it 'is invalid with a wrong format of price ' do
      expect((FactoryBot.build :book, price: 'YTTREW')).not_to be_valid
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
