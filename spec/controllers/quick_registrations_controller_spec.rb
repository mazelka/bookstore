require 'rails_helper'

RSpec.describe QuickRegistrationsController, type: :controller do
  context 'create' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:customer]
    end
    it 'creates new customer' do
      expect do
        post :create, params: { 'customer': { 'email': 'test@asda.com' } }
      end.to change(Customer.all, :count).from(0).to(1)
    end

    it 'creates new customer' do
      post :create, params: { 'customer': { 'email': 'test1@asda.com' } }
      expect(page).to redirect_to carts_path
    end

    it 'does not create new customer if email is invalid' do
      post :create, params: { 'customer': { 'email': 'asda.com' } }
      expect(Customer.all.size).to eq(0)
      expect(flash[:notice]).to be_present
    end
  end

  context 'index' do
    it 'renders template' do
      get :index
      expect(page).to render_template :index
    end
  end
end
