class BooksSorting
  def initialize(books = Book.all)
    @books = books
  end

  def sort(sort = 'created_at', direction = 'asc')
    @books = @books.order("#{sort} #{direction}")
  end
end
