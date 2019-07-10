class ReviewsController < ApplicationController
  before_action :authenticate_customer!, only: :new

  def create
    @review = Review.new(review_params)
    if @review.save
      flash.notice = 'Review was sent to approve!'
    else
      flash.notice = @review.errors.full_messages
    end
    redirect_to book_path(@review.book_id)
  end

  private

  def review_params
    params.require(:review).permit(:id, :title, :text, :book_id).merge(customer: current_customer)
  end
end
