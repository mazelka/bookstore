class CategoriesController < ApplicationController
  def show
    category_books = Category.find(params[:id]).books
    @books = BooksSorting.new(category_books).sort(params[:sort], params[:direction]).page(params[:page]).per(12)
    @active_sorting = params[:active_sorting] || t('books.index.newest_first')
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
