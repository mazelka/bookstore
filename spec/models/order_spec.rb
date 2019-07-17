require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'associations' do
    it { should belong_to(:customer) }
    it { should have_many(:order_items) }
    it { should have_one(:delivery) }
    it { should have_one(:coupon) }
    it { should have_one(:payment) }
    it { should have_one(:shipping_address) }
    it { should have_one(:billing_address) }
  end

  context 'validations' do
    it 'is invalid without customer' do
      expect((build :order, :without_address, customer: nil)).not_to be_valid
    end
  end

  context 'state' do
    it 'allows transition from in_progress to in_queue' do
      expect((create :order, :without_address)).to transition_from(:in_progress).to(:in_queue).on_event(:start_processing)
    end

    it 'allows transition from in_queue to in_delivery' do
      expect((create :order, :without_address)).to transition_from(:in_queue).to(:in_delivery).on_event(:start_delivery)
    end

    it 'allows transition from in_delivery to delivered' do
      expect((create :order, :without_address)).to transition_from(:in_delivery).to(:delivered).on_event(:finish_delivery)
    end

    it 'does not allow transition from in_progress to in_delivery' do
      expect((create :order, :without_address, aasm_state: 'in_progress')).to_not allow_transition_to(:in_delivery)
    end

    it 'does not allow transition from in_delivery to in_queue' do
      expect((create :order, :without_address, aasm_state: 'in_delivery')).to_not allow_transition_to(:in_queue)
    end

    it 'does not allow transition from in_delivery to in_progress' do
      expect((create :order, :without_address, aasm_state: 'in_delivery')).to_not allow_transition_to(:in_progress)
    end

    it 'does not allow transition from canceled to any other state' do
      expect((create :order, :without_address, aasm_state: 'canceled')).to_not allow_transition_to(:in_progress)
      expect((create :order, :without_address, aasm_state: 'canceled')).to_not allow_transition_to(:in_queue)
      expect((create :order, :without_address, aasm_state: 'canceled')).to_not allow_transition_to(:in_delivery)
      expect((create :order, :without_address, aasm_state: 'canceled')).to_not allow_transition_to(:delivered)
    end

    it 'allows transition from any_state to cancel' do
      expect((create :order, :without_address)).to transition_from(:in_progress).to(:canceled).on_event(:cancel)
      expect((create :order, :without_address)).to transition_from(:in_queue).to(:canceled).on_event(:cancel)
      expect((create :order, :without_address)).to transition_from(:in_delivery).to(:canceled).on_event(:cancel)
      expect((create :order, :without_address)).to transition_from(:delivered).to(:canceled).on_event(:cancel)
    end

    it 'has default state unprocessed' do
      expect((create :order, :without_address)).to have_state(:in_progress)
    end
  end
end
