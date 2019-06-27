require 'rails_helper'

RSpec.describe CartDetails do
  context 'when cart has 1 book ' do
    let(:book) { create(:book) }
    let(:cart) { [{ book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: 1 }] }
    let(:cart_details) { CartDetails.new(cart) }

    before :each do
      book
      allow(Book).to receive(:find).and_return book
    end

    it 'has cart' do
      expect(cart_details.instance_variable_get(:@cart)).to_not be_nil
    end

    it 'has coupon = 0 by default' do
      expect(cart_details.instance_variable_get(:@coupon)).to eq(0)
    end

    it 'has subtotal' do
      expect(cart_details.subtotal).to eq(Money.new(book.price.to_f).format)
    end

    it 'has total' do
      expect(cart_details.total).to eq(Money.new(book.price.to_f).format)
    end
  end

  context 'when cart has 2 books and coupon' do
    let(:book_1) { create(:book) }
    let(:book_2) { create(:book) }

    before :each do
      allow(Book).to receive(:find).and_return(book_1, book_2)
      @cart = [{ book_id: book_1.id, title: book_1.title, price: book_1.price, url: book_1.cover_url, quantity: 1 },
               { book_id: book_2.id, title: book_2.title, price: book_2.price, url: book_2.cover_url, quantity: 2 }]
      coupon = 100
      @cart_details = CartDetails.new(@cart, coupon)
    end

    it 'has cart' do
      expect(@cart_details.instance_variable_get(:@cart)).to eq(@cart)
    end

    it 'has coupon' do
      expect(@cart_details.instance_variable_get(:@coupon)).to eq(100)
    end

    it 'has subtotal' do
      expected_subtotal = @cart.each.map { |item| item[:price].to_f * item[:quantity] }.sum
      expect(@cart_details.subtotal).to eq(Money.new(expected_subtotal).format)
    end
  end
end
