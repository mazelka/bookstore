require 'rails_helper'

RSpec.describe BestSellersBooks do
  let!(:books) { create_list(:book, 5) }

  it 'returns 3 bestsellers books' do
    expected_books_list = Category.all.select { |category| category.books.count.positive? }.map do |category|
      category.books.max { |book| book.reviews.count }
    end[0...4]
    expect(BestSellersBooks.call).to match_array(expected_books_list)
  end
end
