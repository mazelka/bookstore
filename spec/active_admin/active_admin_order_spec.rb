require 'rails_helper'

describe 'Order', type: :feature do
  context 'view' do
    let(:order) { create(:order, :complete) }
    before :each do
      order
      sign_in
    end

    it 'visits orders page' do
      visit '/admin/orders'
      expect(page).to have_content('Orders')
      expect(page).to have_selector('#filters_sidebar_section')
      expect(page).to have_selector('#index_table_orders')
    end

    it 'opens existed order' do
      visit '/admin/orders'
      search_order_by_customer_name(order.customer.first_name)
      click_link 'View'
      expect(page).to have_content(order.customer.first_name)
      expect(page).to have_content(order.customer.last_name)
      expect(page).to have_content(order.aasm_state)
      expect(page).to have_content(Money.new(order.total_price).format)
      expect(page).to have_content(order.delivery.name)
      expect(page).to have_no_link('Edit')
      expect(page).to have_no_link('Delete')
    end

    it 'cannot edit/delete/create new order' do
      visit '/admin/orders'
      expect(page).to have_content('Orders')
      expect(page).to have_no_link('Delete')
      expect(page).to have_no_link('Edit')
      expect(page).to have_no_link('New Order')
    end
  end

  context 'when order is in_progress' do
    let(:order) { create(:order) }
    before :each do
      order
      sign_in
    end

    it 'opens show page' do
      visit '/admin/orders'
      search_order_by_customer_name(order.customer.first_name)
      click_link 'View'
      expect(page).to have_no_link('In Delivery')
      expect(page).to have_no_link('Delivered')
      expect(page).to have_no_link('Cancel')
    end

    it 'cannot be updated' do
      visit '/admin/orders'
      search_order_by_customer_name(order.customer.first_name)
      click_link 'View'
      expect(page).to have_content('Order Details')
      expect(page).to have_selector('.row.row-delivery', text: 'Empty')
      expect(page).to have_content('NOT PAID')
    end
  end

  context 'scopes' do
    let(:in_progerss_order) { create(:order) }
    let(:in_queue_order) { create(:order, aasm_state: 'in_queue') }
    let(:in_delivery_order) { create(:order, aasm_state: 'in_delivery') }
    let(:canceled_order) { create(:order, aasm_state: 'canceled') }
    let(:delivered_order) { create(:order, aasm_state: 'delivered') }
    before :each do
      in_progerss_order
      canceled_order
      in_delivery_order
      sign_in
    end

    it 'contain in_progress reviews' do
      visit '/admin/reviews?scope=unprocessed'
      expect(page).to have_content(unprocessed_review.title)
      expect(page).to have_no_content(approved_review.title)
      expect(page).to have_no_content(rejected_review.title)
    end
  end
end
