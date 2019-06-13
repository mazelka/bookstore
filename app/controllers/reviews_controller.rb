class ReviewsController < InheritedResources::Base

  private

    def review_params
      params.require(:review).permit(:title, :text, :book_id)
    end

end
