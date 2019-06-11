require 'spec_helper'
require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:first_name) }
  it { should validate_length_of(:last_name) }
  it { should allow_value('Maashaaa').for(:first_name) }
  it { should allow_value('Kaashaaa').for(:last_name) }
  it { should have_many(:books) }

  context 'associations' do
    author = FactoryBot.create(:author)

    it 'has many books' do
      expect(author).to respond_to :books
    end
  end

  context 'validations' do
    let(:author) { FactoryBot.create :author }

    it 'is invalid without a first_name' do
      expect((FactoryBot.build :author, first_name: nil)).not_to be_valid
    end

    it 'is invalid wihtout a last_name' do
      expect((FactoryBot.build :author, last_name: nil)).not_to be_valid
    end

    it 'is valid without a biography' do
      expect((FactoryBot.build :author, biography: nil)).to be_valid
    end

    it 'has maximum 50 characters lenght of first_name' do
      expect((FactoryBot.build :author, first_name: FFaker::String.from_regexp(/\A[a-zA-Z]{51}\z/))).not_to be_valid
      expect((FactoryBot.build :author, first_name: FFaker::String.from_regexp(/\A[a-zA-Z]{50}\z/))).to be_valid
    end
  end
end
