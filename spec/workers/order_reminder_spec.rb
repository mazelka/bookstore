require 'rails_helper'
RSpec.describe OrderReminder, type: :worker do
  context 'order reminder job' do
    it 'increase size of jobs' do
      expect { OrderReminder.perform_async }.to change(OrderReminder.jobs, :size).by(1)
    end

    it 'has default queue' do
      OrderReminder.perform_async
      expect(OrderReminder.jobs.first['queue']).to eq('default')
    end
  end
  context 'when no orders' do
    before do
      OrderReminder.perform_async
    end
    it 'does not send email' do
      expect { OrderReminder.drain }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'when there is in_progress order' do
    let!(:order) { create :order, :updated_at }

    it 'sends email' do
      OrderReminder.perform_async
      expect { OrderReminder.drain }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'when different orders' do
    let!(:not_completed_order) { create :order, :updated_at }
    let!(:in_queue_order) { create :order, :complete }
    before do
      OrderReminder.perform_async
      OrderReminder.drain
    end

    it 'sends email' do
      expect(ActionMailer::Base.deliveries.first.to).to match_array(not_completed_order.customer.email)
    end
  end
end
