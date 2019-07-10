class CategoriesController < ApplicationController
  def show
    @books = Category.find(params[:id]).books.order('created_at').page(params[:page]).per(12)
    books_count
    popular_categories
    render 'books/index'
  end

  private

  def category_params
    params.require(:category).permit(:id, :title, :text)
  end

  def books_count
    @all_books = Book.all.count
  end

  def popular_categories
    @popular_categories = Category.all.sort { |b, a| a.books.count <=> b.books.count }[0...5]
  end
end
