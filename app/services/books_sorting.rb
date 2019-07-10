class BooksSorting
  def initialize
    @books = Book.all
  end

  def sort(sort = 'created_at', direction = 'asc')
    @books = Book.order("#{sort} #{direction}")
  end

end
