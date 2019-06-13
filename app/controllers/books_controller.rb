class BooksController < InheritedResources::Base

  private

    def book_params
      params.require(:book).permit(:title, :description, :price, :count, :author_id)
    end

end
