class BooksController < ApplicationController
  def index
    @books = Book.limit(20).order(created_at: :asc)
    @popular_categories = Category.all.sort { |b, a| a.books.count <=> b.books.count }[0...3]
    @all_categories = Category.all.count
  end

  def show
    # p params
    # p id
    @book = Book.find(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:id, :title, :description, :price, :inventory, :author_id, :category_id)
  end
end
