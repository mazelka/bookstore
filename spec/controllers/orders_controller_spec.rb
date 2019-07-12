require 'rails_helper'
include ControllerMacros

RSpec.describe OrdersController, type: :controller do
  context 'when authorized customer checkouts' do
    let(:book) { create(:book) }
    let(:order) { create(:order) }
    let(:customer) { create(:customer) }
    before :each do
      customer_set_up_devise
      sign_in customer
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'creates new order object' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :create, session: { cart: cart }
      expect(session[:order_id]).to eq(Order.last.id)
    end

    it 'creates new order item object' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :create, session: { cart: cart }
      expect(OrderItem.last.book.id).to eq(book.id)
      expect(OrderItem.last.quantity).to eq(cart.first[:quantity])
      expect(OrderItem.last.order_id).to eq(Order.last.id)
    end

    it 'assigns customer to order' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :create, session: { cart: cart }
      expect(Order.last.customer).to eq(customer)
    end

    it 'finds order is exists' do
      order
      orders_size = Order.all.size
      post :create, session: { order_id: order.id }
      expect(session[:order_id]).to eq(Order.last.id)
      expect(Order.all.size).to eq(orders_size)
    end

    it 'redirects to cart if cart is empty' do
      post :create
      expect(response).to redirect_to('/carts')
    end

    context 'with applied coupon' do
      let(:coupon) { create(:coupon) }

      it 'adds existed coupon to order' do
        cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
        post :create, session: { coupon_id: coupon.id, cart: cart }
        expect(Order.last.coupon.id).to eq(session[:coupon_id])
      end
    end

    context 'with several books in cart' do
      let(:coupon) { create(:coupon) }
      let(:other_book) { create(:book) }

      it 'adds order items books to order' do
        item_with_book = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }
        item_with_other_book = { book_id: other_book.id, title: other_book.title, price: other_book.price, url: other_book.cover_url, quantity: 1 }
        cart = [item_with_book, item_with_other_book]
        post :create, session: { coupon_id: coupon.id, cart: cart }
        expect(Order.last.order_items.size).to eq(2)
      end
    end
  end

  context 'gest user' do
    let(:book) { create(:book) }
    before do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'force customer to authorize' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :create, session: { cart: cart }
      expect(response).to redirect_to('/quick_registrations')
    end
  end

  context 'index' do
    let(:order) { create(:order) }
    let(:customer) { create(:customer) }
    before :each do
      customer_set_up_devise
      sign_in customer
      order
    end
    it 'renders :index' do
      post :index
      expect(response).to render_template :index
    end

    it 'has default orders_sorting' do
      post :index, params: { current_customer: Customer.last }
      expect(assigns(:orders_sorting)).to eq('In Progress')
    end

    it 'has orders_sorting from params' do
      post :index, params: { sorting: 'Delivered' }
      expect(assigns(:orders_sorting)).to eq('Delivered')
    end

    it 'has orders' do
      post :index, params: { sorting: 'Delivered' }
      expect(assigns(:orders)).not_to be_nil
    end
  end
end
