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
      expect(page).to have_content(order.customer.email)
      expect(page).to have_content(order.aasm_state)
      expect(page).to have_content('Shipping Address')
      expect(page).to have_content('Billing Address')
      expect(page).to have_content('Payment')
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
      in_queue_order
      canceled_order
      in_delivery_order
      delivered_order
      sign_in
    end

    it 'contains in_progress orders' do
      visit '/admin/orders?scope=in_progress'
      expect(page).to have_selector('.col-id', text: in_progerss_order.id)
      expect(page).to have_selector('.col-id', text: in_queue_order.id)
      expect(page).to have_selector('.col-id', text: in_delivery_order.id)
      expect(page).to have_no_selector('.col-id', text: delivered_order.id)
      expect(page).to have_no_selector('.col-id', text: canceled_order.id)
    end

    it 'contains delivered orders' do
      visit '/admin/orders?scope=delivered'
      expect(page).to have_selector('.col-id', text: delivered_order.id)
      expect(page).to have_no_selector('.col-id', text: in_progerss_order.id)
      expect(page).to have_no_selector('.col-id', text: in_queue_order.id)
      expect(page).to have_no_selector('.col-id', text: in_delivery_order.id)
      expect(page).to have_no_selector('.col-id', text: canceled_order.id)
    end

    it 'contains canceled orders' do
      visit '/admin/orders?scope=canceled'
      expect(page).to have_selector('.col-id', text: canceled_order.id)
      expect(page).to have_no_selector('.col-id', text: delivered_order.id)
      expect(page).to have_no_selector('.col-id', text: in_progerss_order.id)
      expect(page).to have_no_selector('.col-id', text: in_queue_order.id)
      expect(page).to have_no_selector('.col-id', text: in_delivery_order.id)
    end

    context 'after changing status' do
      it 'shown in in_progress after start delivery' do
        visit '/admin/orders?scope=in_progress'
        search_order_by_customer_name(in_queue_order.customer.first_name)
        click_link 'View'
        click_link 'In Delivery'
        visit '/admin/orders?scope=in_progress'
        expect(page).to have_selector('.col-id', text: in_queue_order.id)
      end

      it 'shown in delivered after finish delivery' do
        visit '/admin/orders?scope=in_progress'
        search_order_by_customer_name(in_delivery_order.customer.first_name)
        click_link 'View'
        click_link 'Delivered'
        visit '/admin/orders?scope=in_progress'
        expect(page).to have_no_selector('.col-id', text: in_delivery_order.id)
        visit '/admin/orders?scope=delivered'
        expect(page).to have_selector('.col-id', text: in_delivery_order.id)
      end

      it 'shown in canceled after cancel in_queue' do
        visit '/admin/orders?scope=in_progress'
        search_order_by_customer_name(in_queue_order.customer.first_name)
        click_link 'View'
        click_link 'Cancel'
        visit '/admin/orders?scope=in_progress'
        expect(page).to have_no_selector('.col-id', text: in_queue_order.id)
        visit '/admin/orders?scope=canceled'
        expect(page).to have_selector('.col-id', text: in_queue_order.id)
      end

      it 'shown in canceled after cancel delivered' do
        visit '/admin/orders?scope=delivered'
        search_order_by_customer_name(delivered_order.customer.first_name)
        click_link 'View'
        click_link 'Cancel'
        visit '/admin/orders?scope=delivered'
        expect(page).to have_no_selector('.col-id', text: delivered_order.id)
        visit '/admin/orders?scope=canceled'
        expect(page).to have_selector('.col-id', text: delivered_order.id)
      end

      it 'shown in canceled after cancel in_delivery' do
        visit '/admin/orders?scope=in_progress'
        search_order_by_customer_name(in_delivery_order.customer.first_name)
        click_link 'View'
        click_link 'Cancel'
        visit '/admin/orders?scope=in_progress'
        expect(page).to have_no_selector('.col-id', text: in_delivery_order.id)
        visit '/admin/orders?scope=canceled'
        expect(page).to have_selector('.col-id', text: in_delivery_order.id)
      end
    end
  end
  context 'when order in progress' do
    let!(:order) { create(:order, :with_customer) }
    before do
      sign_in
    end

    it 'shows available order details' do
      visit '/admin/orders'
      search_order_by_customer_name(order.customer.first_name)
      click_link 'View'
      expect(page).to have_content(order.customer.first_name)
      expect(page).to have_content(order.customer.last_name)
      expect(page).to have_content(order.customer.email)
      expect(page).to have_selector('.row-shipping_address', text: 'Empty')
      expect(page).to have_selector('.row-shipping_address', text: 'Empty')
      expect(page).to have_selector('.row-payment .status_tag', text: 'NOT PAID')
      expect(page).to have_selector('.row-status .status_tag', text: 'in_progress')
      expect(page).to have_content(Money.new(order.total_price).format)
      expect(page).to have_selector('.row-delivery', text: 'Empty')
      expect(page).to have_no_link('Edit')
      expect(page).to have_no_link('Delete')
      expect(page).to have_no_link('Cancel')
      expect(page).to have_no_link('In Delivery')
    end
  end
end
