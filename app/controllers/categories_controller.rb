class CategoriesController < ApplicationController
  private

  def category_params
    params.require(:category).permit(:id, :title, :text)
  end
end
