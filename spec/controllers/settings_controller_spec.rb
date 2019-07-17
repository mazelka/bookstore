require 'rails_helper'
include ControllerMacros

RSpec.describe SettingsController, type: :controller do
  context 'index' do
    it 'renders :index' do
      get :index
      expect(page).to render_template :index
    end
  end

  context 'update' do
    let(:customer) { create(:customer) }

    before :each do
      customer
      sign_in customer
    end

    it 'email and names' do
      put :update, params: { customer: { email: 'test@test.com', first_name: 'Fisrt name', last_name: 'Last name' } }
      changed_customer = Customer.find_by(email: 'test@test.com')
      expect(changed_customer.first_name).to eq('Fisrt name')
      expect(changed_customer.last_name).to eq('Last name')
    end

    it 'does not save invalid email' do
      put :update, params: { customer: { email: 'testest.com' } }
      expect(Customer.all.size).to eq(1)
      expect(Customer.last.email).to eq(customer.email)
    end

    it 'addresses' do
      address = { address_line: '123 ewfa asdfasdf', country: 'sdf', city: 'fasdf', zip: '123', phone: '+123413' }
      put :update, params: { customer: { shipping_address_attributes: address, billing_address_attributes: address } }
      changed_customer = Customer.find_by(email: customer.email)
      expect(changed_customer.shipping_address).to_not be_nil
      expect(changed_customer.billing_address).to_not be_nil
    end

    it 'does not save invalid address' do
      address = { address_line: '', country: 'sdf', city: 'fasdf', zip: '123', phone: '+123413' }
      put :update, params: { customer: { shipping_address_attributes: address, billing_address_attributes: address } }
      changed_customer = Customer.find_by(email: customer.email)
      expect(changed_customer.shipping_address).to be_nil
      expect(changed_customer.billing_address).to be_nil
    end
  end
end
