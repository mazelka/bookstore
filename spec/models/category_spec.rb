require 'spec_helper'
require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should have_many(:books) }

  context 'associations' do
    category = FactoryBot.create(:category)

    it 'has many books' do
      expect(category).to respond_to :books
    end
  end

  context 'validations' do
    let(:category) { FactoryBot.create :category }

    it 'is invalid without a title' do
      expect((FactoryBot.build :category, title: nil)).not_to be_valid
    end

    it 'is invalid wiht not unique title' do
      expect((FactoryBot.create :category, title: 'masha')).to be_valid
      expect((FactoryBot.build :category, title: 'masha')).not_to be_valid
    end
  end
end
