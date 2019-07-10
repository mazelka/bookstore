class HomeController < ApplicationController
  def index
    @latest_books = Book.latest
    @bestsellers = BestSellersBooks.call
  end
end
