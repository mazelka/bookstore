require 'rails_helper'

RSpec.describe CartsController do
  before :each do
    session[:cart] ||= []
  end

  context 'empty cart' do
    it 'render cart' do
      get :show_cart
      expect(response).to render_template :cart
    end
    it 'does not have items' do
      get :show_cart
      expect(assigns(:cart)).to match_array([])
    end
    it 'does not have coupon' do
      get :show_cart
      expect(assigns(:coupon)).to eq(0)
    end

    it 'has cart details' do
      get :show_cart
      expect(assigns(:cart_details)).to_not be_nil
    end
  end

  context 'when adds 1 book to cart' do
    let(:book) { create(:book) }
    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'has book properties in cart' do
      item = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      expect(assigns(:cart)).to match_array([item])
    end

    it 'has successful message' do
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      expect(flash[:notice]).to be_present
    end

    it 'redirects to added book page' do
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      expect(response).to redirect_to("/books/#{book.id}")
    end

    it 'has updated cart in session' do
      item = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      expect(session[:cart]).to match_array([item])
    end
  end

  context 'adds more than 1 book' do
    let(:first_book) { create(:book) }
    let(:second_book) { create(:book) }
    before :each do
      allow(Book).to receive(:find).and_return(first_book, second_book)
    end

    it 'has 2 different books in cart' do
      first_item = { book_id: first_book.id, title: first_book.title, price: first_book.price, url: first_book.cover_url, quantity: 1 }
      second_item = { book_id: second_book.id, title: second_book.title, price: second_book.price, url: second_book.cover_url, quantity: 1 }
      post :add_to_cart, params: { id: first_book.id, quantity: 1 }
      post :add_to_cart, params: { id: second_book.id, quantity: 1 }
      expect(assigns(:cart)).to eq([first_item, second_item])
    end

    it 'has 1 the same book in cart' do
      post :add_to_cart, params: { id: first_book.id, quantity: 2 }
      expect(assigns(:cart).size).to eq(1)
      expect(assigns(:cart).first[:quantity]).to eq(2)
    end
  end

  context 'adds the same book' do
    let(:book) { create(:book) }
    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it '3 times' do
      item = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 3 }
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      post :add_to_cart, params: { id: book.id, quantity: 1 }
      expect(session[:cart]).to eq([item])
    end
  end

  context 'removes' do
    let(:book) { create(:book) }
    let(:last_book) { create(:book) }
    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'book has quantity 1' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :remove_item, params: { id: book.id }, session: { cart: cart }
      expect(assigns(:cart)).to match_array([])
    end

    it 'cart has 2 different books' do
      last_item = { book_id: last_book.id, title: last_book.title, price: last_book.price, url: last_book.cover_url, quantity: 1 }
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }, last_item]
      post :remove_item, params: { id: book.id }, session: { cart: cart }
      expect(assigns(:cart)).to match_array([last_item])
    end

    it 'book has quantity 2' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }]
      post :remove_item, params: { id: book.id }, session: { cart: cart }
      expect(assigns(:cart)).to match_array([])
    end

    it 'has updated cart in session' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }]
      post :remove_item, params: { id: book.id }, session: { cart: cart }
      expect(session[:cart]).to match_array([])
    end
  end

  context 'when increase quantity' do
    let(:book) { create(:book) }
    let(:cart) { [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }] }
    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'redirects back' do
      request.env['HTTP_REFERER'] = '/cart'
      get :show_cart
      post :increase_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(response).to redirect_to('/cart')
    end

    it 'book quantity increases by 1' do
      post :increase_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(assigns(:cart).first[:quantity]).to eq(2)
    end

    it 'has updated cart in session' do
      post :increase_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(session[:cart]).to eq([{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }])
    end
  end

  context 'when decrease quantity' do
    let(:book) { create(:book) }
    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'redirects back' do
      request.env['HTTP_REFERER'] = '/cart'
      get :show_cart
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }]
      post :decrease_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(response).to redirect_to('/cart')
    end

    it 'book quantity decreases by 1' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }]
      post :decrease_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(assigns(:cart).first[:quantity]).to eq(1)
    end

    it 'book quantity has minimum 1' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }]
      post :decrease_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(assigns(:cart).first[:quantity]).to eq(1)
    end

    it 'has updated cart in session' do
      cart = [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 2 }]
      post :decrease_quantity, params: { book_id: book.id }, session: { cart: cart }
      expect(session[:cart]).to eq([{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }])
    end
  end

  context 'applying valid coupon' do
    let(:book) { create(:book) }
    let(:coupon) { create(:coupon) }
    let(:cart) { [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }] }
    before :each do
      book
      cart
      allow(Book).to receive(:find).and_return book
    end

    it 'renders cart' do
      request.env['HTTP_REFERER'] = '/cart'
      get :show_cart
      post :apply_coupon, params: { coupon: coupon.name }, session: { cart: cart }
      expect(response).to redirect_to('/cart')
    end

    it 'has success message' do
      post :apply_coupon, params: { coupon: coupon.name }, session: { cart: cart }
      expect(flash[:notice]).to be_present
    end

    it 'has disacount value' do
      post :apply_coupon, params: { coupon: coupon.name }, session: { cart: cart }
      expect(assigns(:coupon)).to eq(coupon.discount)
    end

    it 'has updated value in session' do
      post :apply_coupon, params: { coupon: coupon.name }, session: { cart: cart }
      expect(session[:coupon_id]).to be_present
    end

    it 'has cart details' do
      post :apply_coupon, params: { coupon: coupon.name }, session: { cart: cart }
      expect(assigns(:cart_details)).not_to be_nil
    end
  end

  context 'applying invalid coupon' do
    let(:book) { create(:book) }
    let(:cart) { [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }] }
    before :each do
      cart
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'redirects back' do
      request.env['HTTP_REFERER'] = '/cart'
      get :show_cart
      post :apply_coupon, params: { coupon: 'not existed' }, session: { cart: cart }
      expect(response).to redirect_to('/cart')
    end

    it 'has error message' do
      post :apply_coupon, params: { coupon: 'not existed' }, session: { cart: cart }
      expect(flash[:notice]).to be_present
    end

    it 'does not have disacount value' do
      post :apply_coupon, params: { coupon: 'not existed' }, session: { cart: cart }
      expect(assigns(:coupon)).to be_nil
    end
  end
end
