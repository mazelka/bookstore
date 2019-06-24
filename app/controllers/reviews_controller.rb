class ReviewsController < ApplicationController
  before_action :authenticate_customer!, only: :create

  def create
    @review = Review.new(title: params[:title], text: params[:review], book_id: params[:book_id], customer: @current_customer)
    if @review.save
      flash.notice = 'Review was sent to approve!'
    else
      flash.notice = @review.errors.full_messages
    end
    redirect_to book_path(@review.book_id)
  end

  private

  def review_params
    params.require(:review).permit(:id, :title, :text, :book_id, :customer_id)
  end
end
