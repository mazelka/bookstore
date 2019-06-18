class BooksController < ApplicationController
  def index
    @books = Book.page(params[:page]).per(12)
    @popular_categories = Category.all.sort { |b, a| a.books.count <=> b.books.count }[0...5]
    @all_books = Book.all.count
  end

  def show
    @book = Book.find(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:id, :title, :description, :price, :inventory, :author_id, :category_id)
  end
end
