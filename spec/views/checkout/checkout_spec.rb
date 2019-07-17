require 'rails_helper'
include Authentication

describe 'checkout', type: :feature do
  context 'empty cart' do
    it 'checkout button is disabled' do
      visit '/carts'
      expect(page).to have_content('You don`t have added books. Go and find something in Catalog!')
      expect(page).to have_selector('.btn.btn-default.mb-20.hidden-xs.center-block.check-center.disabled')
    end
  end

  context 'not logged customer' do
    let!(:book) { create(:book) }

    it 'redirects to login' do
      visit "/books/#{book.id}"
      page.find_button('Add to Cart').click
      visit '/carts'
      page.find_link('Checkout').click
      expect(current_path).to eq(quick_registrations_path)
    end
  end

  context 'logged user with cart' do
    let!(:customer) { create(:customer, :with_addresses) }
    let!(:delivery) { create(:delivery) }
    let!(:coupon) { create(:coupon) }
    let!(:book) { create(:book) }

    before do
      customer_sign_in_with(customer)
    end

    it 'creates order with coupon' do
      visit "/books/#{book.id}"
      page.find_button('Add to Cart').click
      visit '/carts'
      page.find('.form-control.coupon-input.mb-30').set(coupon.name)
      page.find_button('Apply Coupon').click
      page.find_link('Checkout').click
      within('.billing-section') do
        page.find('#order_billing_address_attributes_address_line').set('321 test lane')
        page.find('#order_billing_address_attributes_country').set('USA')
        page.find('#order_billing_address_attributes_city').set('NY')
        page.find('#order_billing_address_attributes_zip').set('49000')
        page.find('#order_billing_address_attributes_phone').set('+123456789')
      end
      page.find_button('Save and continue').click
      page.find_button('Save and continue').click
      page.find('#payment_attributes_card_number').set('1234123412341234')
      page.find('#payment_attributes_name').set('Test Name')
      page.find('#payment_attributes_expire').set('12/28')
      page.find('#payment_attributes_cvv').set('1234')
      page.find_button('Save and continue').click
      page.find_link('Place Order').click
      expect(page).to have_content('Thank You for your Order!')
      page.find_link('Back to Store').click
      expect(current_path).to eq(root_path)
    end
  end
end
