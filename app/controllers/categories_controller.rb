class CategoriesController < ApplicationController
  scope :featured, order('jobs_count DESC')

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
