module BooksHelper
  def dropdown_with_links
    if current_page?('/books')
      render partial: 'books/sort_drop_down', locals: { active_controller: 'books', action: :index }
    else
      render partial: 'books/sort_drop_down', locals: { active_controller: 'categories', action: :show }
    end
  end
end
