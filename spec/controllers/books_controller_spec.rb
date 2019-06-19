require 'rails_helper'

RSpec.describe BooksController do
  context 'template' do
    let(:book) { build_stubbed(:book) }

    it 'renders :index template' do
      get :index
      expect(response).to render_template :index
    end
    it 'renders :index template for price_low_to_high' do
      get :price_low_to_high
      expect(response).to render_template :index
    end
    it 'renders :index template for popular_first' do
      get :popular_first
      expect(response).to render_template :index
    end
    it 'renders :index template for price_high_to_low' do
      get :price_high_to_low
      expect(response).to render_template :index
    end
  end

  context 'assigns @active_sorting' do
    let(:book) { build_stubbed(:book) }

    it 'is Newest first by default' do
      get :index
      expect(assigns(:active_sorting)).to eq('Newest first')
    end
    it 'is Price: Low to high' do
      get :price_low_to_high
      expect(assigns(:active_sorting)).to eq('Price: Low to high')
    end
    it 'is Popular first' do
      get :popular_first
      expect(assigns(:active_sorting)).to eq('Popular first')
    end
    it 'is Price: High to low' do
      get :price_high_to_low
      expect(assigns(:active_sorting)).to eq('Price: High to low')
    end
  end

  context 'books sorting' do
    let(:books) { 3.times { create(:book) } }

    before :each do
      books
    end

    it 'shows newest books by default' do
      get :index
      expect(assigns(:books)).to match_array(Book.order('created_at'))
    end

    it 'shows books in order by price low to high' do
      get :price_low_to_high
      expect(assigns(:books)).to match_array(Book.order(:price))
    end

    it 'shows books in order by price high to low' do
      get :price_high_to_low
      expect(assigns(:books)).to match_array(Book.order(price: :desc))
    end

    it 'shows books in order by popularity' do
      get :popular_first
      expect(assigns(:books)).to match_array(Book.order(inventory: :desc))
    end
  end

  context 'attributes' do
    let(:book) { create(:book) }

    before :each do
      book
    end

    it 'has books_count' do
      get :index
      expect(assigns(:all_books)).to eq(1)
    end

    context 'popular category' do
      let!(:most_pop_category) { create(:category) }
      let!(:books) { 5.times { create(:book, category: most_pop_category) } }
      let!(:pop_category) { create(:category) }
      let!(:book) { create(:book, category: pop_category) }

      it 'has popular_categories' do
        get :index
        popular_categories = Category.all.sort { |b, a| a.books.count <=> b.books.count }[0...5]
        expect(assigns(:popular_categories)).to eq(popular_categories)
      end
    end
  end

  context '#show' do
    let(:book) { build_stubbed(:book) }
    before do
      book
      allow(Book).to receive(:find).and_return book
    end
    it 'renders :show template' do
      get :show, params: { id: book.id }
      expect(response).to render_template :show
    end
    it 'has quantity 1 by default' do
      get :show, params: { id: book.id }
      expect(assigns(:quantity)).to eq(1)
    end
  end
end
