require 'rails_helper'
include Authentication

describe 'settings', type: :feature do
  context 'address' do
    let(:customer) { create(:customer) }
    before :each do
      customer_sign_in_with(customer)
    end

    it 'fills in addresses' do
      visit '/settings'
      within('.shipping-section') do
        page.find('#customer_shipping_address_attributes_address_line').set('123 test lane')
        page.find('#customer_shipping_address_attributes_country').set('Ukraine')
        page.find('#customer_shipping_address_attributes_city').set('Dnipro')
        page.find('#customer_shipping_address_attributes_zip').set('49000')
        page.find('#customer_shipping_address_attributes_phone').set('+123456789')
      end
      within('.billing-section') do
        page.find('#customer_billing_address_attributes_address_line').set('321 test lane')
        page.find('#customer_billing_address_attributes_country').set('USA')
        page.find('#customer_billing_address_attributes_city').set('NY')
        page.find('#customer_billing_address_attributes_zip').set('49000')
        page.find('#customer_billing_address_attributes_phone').set('+123456789')
      end
      page.find('.submit-address-button').click
      expect(page).to have_content('Your settings updated!')
    end
  end

  context 'privacy' do
    let(:customer) { create(:customer) }
    before :each do
      customer_sign_in_with(customer)
    end

    it 'updates email' do
      visit '/settings'
      page.find('.privacy-tab').click
      page.find('#customer_email').set('test@test.com')
      find_button('Update Email').click
      expect(page).to have_content('Your settings updated!')
    end

    it 'updates password' do
      visit '/settings'
      page.find('.privacy-tab').click
      page.find('.current-password').set(customer.password)
      page.find('.new-password').set('Gfhjkm22')
      page.find('.confirm-password').set('Gfhjkm22')
      find_button('Update Password').click
      expect(page).to have_content('Your settings updated!')
    end

    it 'remove customer' do
      visit '/settings'
      page.find('.privacy-tab').click
      within('.remove-customer-section') do
        page.find('.checkbox-label').click
        page.find('.remove-customer').click
      end
      expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
    end
  end
end
