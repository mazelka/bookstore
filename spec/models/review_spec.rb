require 'spec_helper'
require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:text) }
  it { should validate_length_of(:title) }
  it { should validate_length_of(:text) }
  it { should allow_value('Maashaaa').for(:title) }
  it { should allow_value('123').for(:title) }
  it { should allow_value("!#$%&'*+-\/=?^_`{|}~").for(:title) }
  it { should allow_value('Kaashaaa').for(:text) }
  it { should allow_value('123').for(:text) }
  it { should allow_value("!#$%&'*+-\/=?^_`{|}~").for(:text) }
  it { should belong_to(:book) }
  it { should belong_to(:customer) }

  context 'associations' do
    review = FactoryBot.create(:review)

    it 'belongs to customer' do
      expect(review).to respond_to :customer
    end

    it 'belongs to book' do
      expect(review).to respond_to :book
    end
  end

  context 'validations' do
    it 'is invalid without a title' do
      expect((FactoryBot.build :review, title: nil)).not_to be_valid
    end

    it 'is invalid with a title more than 80 characters' do
      expect((FactoryBot.build :review, title: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{81}\z/))).not_to be_valid
    end

    it 'is invalid without a text' do
      expect((FactoryBot.build :review, text: nil)).not_to be_valid
    end

    it 'is invalid with a textmore than 80 characters' do
      expect((FactoryBot.build :review, text: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{501}\z/))).not_to be_valid
    end

    it 'is invalid without a book' do
      expect((FactoryBot.build :review, book: nil)).not_to be_valid
    end

    it 'is invalid without a customer' do
      expect((FactoryBot.build :review, customer: nil)).not_to be_valid
    end

    it 'allows special characters in a text' do
      expect((FactoryBot.build :review, text: "!#$%&'*+-\/=?^_`{|}~")).to be_valid
    end

    it 'allows special characters in a title' do
      expect((FactoryBot.build :review, title: "!#$%&'*+-\/=?^_`{|}~")).to be_valid
    end
  end
end
