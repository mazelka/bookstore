class HomeController < ApplicationController
  def index
    @latest_books = Book.order('created_at').last(3)
    @bestsellers = Category.all.select { |category| category.books.count.positive? }.map do |category|
      category.books.max { |book| book.reviews.count }
    end[0...4]
  end
end
