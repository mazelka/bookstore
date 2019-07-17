require 'rails_helper'

RSpec.describe BooksSorting do
  context 'default config' do
    let!(:books) { create_list(:book, 5) }

    it 'sorts all books by default' do
      expect(BooksSorting.new.instance_variable_get(:@books)).to eq(Book.all)
    end

    it 'sorts books by default as created_at asc' do
      expect(BooksSorting.new.sort).to match_array(Book.order('created_at'))
    end
  end

  context 'all books' do
    let!(:books) { create_list(:book, 5) }

    it 'sorts books by reviews_count desc' do
      expect(BooksSorting.new.sort('reviews_count', 'desc')).to match_array(Book.order(reviews_count: :desc))
    end

    it 'sorts books by price desc' do
      expect(BooksSorting.new.sort('price', 'desc')).to match_array(Book.order(price: :desc))
    end

    it 'sorts books by price asc' do
      expect(BooksSorting.new.sort('price', 'asc')).to match_array(Book.order(price: :asc))
    end
  end

  context 'in category' do
    let(:category) { create(:category, title: 'Test Title') }
    let(:in_category_books) { create_list(:book, 5, category: category) }
    let(:books) { create_list(:book, 5) }
    before do
      in_category_books
      books
    end

    it 'initializes with books in category' do
      category_books = Category.find(category.id).books
      expect(BooksSorting.new(category_books).instance_variable_get(:@books)).to eq(category_books)
    end

    it 'sorts books in category by reviews_count desc' do
      category_books = Category.find(category.id).books
      expect(BooksSorting.new(category_books).sort('reviews_count', 'desc')).to match_array(category_books.order(reviews_count: :desc))
    end

    it 'sorts books by price desc' do
      category_books = Category.find(category.id).books
      expect(BooksSorting.new(category_books).sort('price', 'desc')).to match_array(category_books.order(price: :desc))
    end

    it 'sorts books by price asc' do
      category_books = Category.find(category.id).books
      expect(BooksSorting.new(category_books).sort('price', 'asc')).to match_array(category_books.order(price: :asc))
    end
  end
end
