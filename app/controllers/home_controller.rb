class HomeController < ApplicationController
  def index
    @latest_books = Book.order('created_at').last(3)
  end
end
