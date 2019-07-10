class AuthorsController < ApplicationController
  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end
end
