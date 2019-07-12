require 'rails_helper'
include ControllerMacros

RSpec.describe CheckoutController, type: :controller do
  context 'show' do
    context 'guest customer' do
      let(:order) { create(:order) }
      let(:customer) { create(:customer) }

      it 'redirects to registration if unauthorized' do
        get :show, params: { id: :address }, session: { order_id: order.id }
        expect(response).to redirect_to('/quick_registrations')
      end
    end

    context 'logged customer' do
    let(:order) { create(:order) }
    let(:customer) { create(:customer) }
    before :each do
      customer_set_up_devise
      sign_in customer
    end
     it 'redirects to cart if there is not order in session' do
      get :show, params: { id: :address }
        expect(response).to redirect_to('/carts')
     end
  end
  end
end
