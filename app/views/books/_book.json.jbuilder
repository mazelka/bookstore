json.extract! book, :id, :title, :description, :price, :count, :author_id, :created_at, :updated_at
json.url book_url(book, format: :json)
