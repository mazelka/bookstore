class BooksController < ApplicationController
  def index
    @books = BooksSorting.new.sort(params[:sort], params[:direction]).page(params[:page]).per(12)
    @active_sorting = params[:active_sorting] || t('.newest_first')
    books_count
    popular_categories
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.approved
    @quantity = 1
  end

  private

  def books_count
    @all_books = Book.all.count
  end

  def popular_categories
    @popular_categories = Category.all.sort { |b, a| a.books.count <=> b.books.count }[0...5]
  end

  def book_params
    params.require(:book).permit(:id, :title, :description, :price, :inventory, :author_id, :category_id)
  end
end
