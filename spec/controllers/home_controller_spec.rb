require 'rails_helper'

RSpec.describe HomeController do
  context 'template' do
    let(:book) { build_stubbed(:book) }
    it 'renders :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  context 'latest books' do
    let(:books) { create_list(:book, 3) }
    before :each do
      books
    end

    it 'create books collection' do
      get :index
      expect(assigns(:latest_books)).to_not be_nil
    end

    it 'include last 3 added books' do
      get :index
      expect(assigns(:latest_books)).to eql(Book.order('created_at').last(3))
    end
  end

  context 'bestsellers' do
    let(:books) { create_list(:book, 3) }
    before :each do
      books
    end

    it 'create books collection' do
      get :index
      expect(assigns(:bestsellers)).to_not be_nil
    end

    it 'include 4 most ordered books' do
      get :index
      bestsellers = Category.all.select { |category| category.books.count.positive? }.map do |category|
        category.books.max { |book| book.reviews.count }
      end[0...4]
      expect(assigns(:bestsellers)).to eql(bestsellers)
    end
  end
end
