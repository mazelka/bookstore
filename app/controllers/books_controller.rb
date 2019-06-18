class BooksController < ApplicationController
  def index
    @books = Book.order('created_at').page(params[:page]).per(12)
    @active_sorting = 'Newest first'
    books_count
    popular_categories
  end

  def show
    @book = Book.find(params[:id])
    @quantity = 1
  end

  def price_low_to_high
    @books = Book.order(:price).page(params[:page]).per(12)
    books_count
    popular_categories
    @active_sorting = 'Price: Low to high'
    render 'index'
  end

  def popular_first
    @books = Book.order(inventory: :desc).page(params[:page]).per(12)
    books_count
    popular_categories
    @active_sorting = 'Popular first'
    render 'index'
  end

  def price_high_to_low
    @books = Book.order(price: :desc).page(params[:page]).per(12)
    books_count
    popular_categories
    @active_sorting = 'Price: High to low'
    render 'index'
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
