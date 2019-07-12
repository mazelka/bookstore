require 'rails_helper'
include ControllerMacros

RSpec.describe CheckoutController, type: :controller do
  context 'guest customer' do
    let(:order) { create(:order) }

    it 'redirects to registration if unauthorized' do
      get :show, params: { id: :address }, session: { order_id: order.id }
      expect(response).to redirect_to('/quick_registrations')
    end
  end

  context 'logged customer' do
    let(:customer) { create(:customer) }
    let(:order) { create(:order, :complete, customer: customer) }

    before :each do
      customer_set_up_devise
      sign_in customer
    end

    it 'redirects to cart if there is not order in session' do
      get :show, params: { id: :address }
      expect(response).to redirect_to('/carts')
    end

    it 'sees all deliveries' do
      get :show, params: { id: :delivery }, session: { order_id: order.id }
      expect(assigns(:delivery)).to eq(Delivery.all)
    end

    it 'loses all order data in session on complete' do
      get :show, params: { id: :complete }, session: { order_id: order.id }
      expect(session[:cart]).to be_nil
      expect(session[:coupon_id]).to be_nil
      expect(session[:order_id]).to be_nil
    end
  end

  context 'render template' do
    let(:customer) { create(:customer) }
    let(:order) { create(:order, :complete) }

    before :each do
      customer_set_up_devise
      sign_in customer
    end

    it 'address page' do
      get :show, params: { id: :address }, session: { order_id: order.id }
      expect(response).to render_template 'checkout/address'
    end
    it 'delivery page' do
      get :show, params: { id: :delivery }, session: { order_id: order.id }
      expect(response).to render_template 'checkout/delivery'
    end
    it 'payment page' do
      get :show, params: { id: :payment }, session: { order_id: order.id }
      expect(response).to render_template 'checkout/payment'
    end
    it 'confirmation page' do
      get :show, params: { id: :confirmation }, session: { order_id: order.id }
      expect(response).to render_template 'checkout/confirmation'
    end
    it 'complete page' do
      get :show, params: { id: :complete }, session: { order_id: order.id }
      expect(response).to render_template 'checkout/complete'
    end
  end

  context 'update' do
    context 'address' do
      let(:customer) { create(:customer) }
      let(:order) { create(:order, :with_customer, customer: customer) }

      before :each do
        customer_set_up_devise
        sign_in customer
      end

      it 'when customer does not have address' do
        shipping_address = { 'address_line' => '123 qdf asdf', 'country' => 'qwe', 'city' => 'qwer', 'zip' => '12', 'phone' => '+12453' }
        billing_address = { 'address_line' => '1234 sdf asd', 'country' => 'qwe', 'city' => 'qwer', 'zip' => '12', 'phone' => '+12453' }
        put :update, params: { billing_addres_attributes: billing_address, shipping_address_attributes: shipping_address, id: :address }, session: { order_id: order.id }
        expect(order.shipping_address.present?).to be true
        expect(order.billing_address.present?).to be true
      end

      it 'does not save invalid address' do
        shipping_address = { 'address_line' => 'asdf', 'country' => 'qwe', 'city' => 'qwer', 'zip' => '12', 'phone' => '+12453' }
        billing_address = { 'address_line' => 'asd', 'country' => 'qwe', 'city' => 'qwer', 'zip' => '12', 'phone' => '+12453' }
        put :update, params: { billing_addres_attributes: billing_address, shipping_address_attributes: shipping_address, id: :address }, session: { order_id: order.id }
        expect(order.shipping_address.present?).to be false
        expect(order.billing_address.present?).to be false
      end
    end

    context 'delivery' do
      let(:customer) { create(:customer) }
      let(:delivery) { create(:delivery) }
      let(:order) { create(:order, :with_customer, customer: customer) }

      before :each do
        customer_set_up_devise
        sign_in customer
      end

      it 'adds delivery to order' do
        put :update, params: { delivery_id: delivery.id, id: :delivery }, session: { order_id: order.id }
        expect(order.delivery.present?).to be true
        expect(order.delivery).to eq(delivery)
      end
    end

    context 'payment' do
      let(:customer) { create(:customer) }
      let(:order) { create(:order, :with_customer, customer: customer) }

      before :each do
        customer_set_up_devise
        sign_in customer
      end

      it 'adds delivery to order' do
        payment_attributes = { 'card_number' => '1234123412341234', 'name' => 'My Test', 'expire' => '09/29', 'cvv' => '432' }
        put :update, params: { payment_attributes: payment_attributes, id: :payment }, session: { order_id: order.id }
        expect(order.payment.present?).to be true
      end

      it 'does not save invalid payment' do
        payment_attributes = { 'card_number' => '1233412341234', 'name' => 'My Test', 'expire' => '09/29', 'cvv' => '432' }
        put :update, params: { payment_attributes: payment_attributes, id: :payment }, session: { order_id: order.id }
        expect(order.payment.present?).to be false
        expect(response).to render_template 'checkout/payment'
      end
    end

    context 'confirmation' do
      let(:customer) { create(:customer) }

      before :each do
        customer_set_up_devise
        sign_in customer
      end

      # it "order change status to 'in_queue'" do
      #   order = create(:order, :complete, aasm_state: 'in_progress', customer: customer)
      #   put :update, params: { id: :confirmation }, session: { order_id: order.id }
      #   expect(order.aasm_state).to eq('in_queue')
      # end

      it 'has the same status if some attribute is missing' do
        order = create(:order, :with_customer, aasm_state: 'in_progress', customer: customer)
        put :update, params: { id: :confirmation }, session: { order_id: order.id }
        expect(order.aasm_state).to eq('in_progress')
      end
    end
  end
end
