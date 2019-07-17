require 'rails_helper'
include Authentication

describe 'orders', type: :feature do
  context 'list of orders' do
    let!(:customer) { create(:customer) }
    let!(:in_queue_order) { create(:order, :with_customer, customer: customer, aasm_state: 'in_queue') }
    let!(:in_delivery_order) { create(:order, :with_customer, customer: customer, aasm_state: 'in_delivery') }
    let!(:delivered_order) { create(:order, :with_customer, customer: customer, aasm_state: 'delivered') }
    let!(:canceled_order) { create(:order, :with_customer, customer: customer, aasm_state: 'canceled') }
    before :each do
      customer_sign_in_with(customer)
    end

    it 'sees all his orders' do
      visit '/orders'
      expect(page).to have_content('My Orders')
      expect(page).to have_content('All')
    end

    it 'sees only orders in progress' do
      visit '/orders'
      expect(page).to have_content('My Orders')
      page.find('.general-order-dropdown').click
      within('.general-order-dropdown') do
        find(:link, text: 'In Progress').click
      end
      table = page.find('.table')
      expect(table).to have_no_content('Delivered')
      expect(table).to have_no_content('In Delivery')
      expect(table).to have_no_content('Canceled')
    end

    it 'sees only canceled orders' do
      visit '/orders'
      expect(page).to have_content('My Orders')
      page.find('.general-order-dropdown').click
      within('.general-order-dropdown') do
        find(:link, text: 'Canceled').click
      end
      table = page.find('.table')
      expect(table).to have_no_content('In Delivery')
      expect(table).to have_no_content('In Queue')
      expect(table).to have_no_content('Delivered')
    end

    it 'sees only delivered orders' do
      visit '/orders'
      expect(page).to have_content('My Orders')
      page.find('.general-order-dropdown').click
      within('.general-order-dropdown') do
        find(:link, text: 'In Delivery').click
      end
      table = page.find('.table')
      expect(table).to have_no_content('In Progress')
      expect(table).to have_no_content('Delivered')
      expect(table).to have_no_content('Canceled')
    end
  end
end
