class ReviewsController < ApplicationController
  private

  def review_params
    params.require(:review).permit(:id, :title, :text, :book_id)
  end
end
