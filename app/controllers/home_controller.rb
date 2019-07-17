class HomeController < ApplicationController
  def index
    @latest_books = Book.latest
    @books = BestSellersBooks.call
  end
end
