class ReviewsController < ApplicationController
  def create
    if customer_signed_in?
      @review = Review.new(title: params[:title], text: params[:review], book_id: params[:book_id], customer: @current_customer)
      if @review.valid?
        @review.save
        flash.notice = 'Review was sent to approve!'
      else
        flash.notice = @review.errors.full_messages
      end
      redirect_to book_path(@review.book_id)
    else
      flash.notice = 'Please login'
    end
  end

  def approve
    @review = Review.find(params[:id]).approve
    @review.save
  end

  def reject
    @review = Review.find(params[:id]).reject
    @review.save
  end

  private

  def review_params
    params.require(:review).permit(:id, :title, :text, :book_id, :customer_id)
  end
end
