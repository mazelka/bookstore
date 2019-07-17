require 'spec_helper'
require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:customer) }
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

  context 'state' do
    it 'allows transition from unprocessed to approved' do
      expect((FactoryBot.create :review)).to transition_from(:unprocessed).to(:approved).on_event(:approve)
    end

    it 'allows transition from unprocessed to reject' do
      expect((FactoryBot.create :review)).to transition_from(:unprocessed).to(:rejected).on_event(:reject)
    end

    it 'does not allow transition from approve to reject' do
      expect((FactoryBot.create :review, aasm_state: 'approved')).to_not allow_transition_to(:rejected)
    end

    it 'does not allow transition from reject to approve' do
      expect((FactoryBot.create :review, aasm_state: 'rejected')).to_not allow_transition_to(:approved)
    end

    it 'has default state unprocessed' do
      expect((FactoryBot.create :review)).to have_state(:unprocessed)
    end
  end
end
