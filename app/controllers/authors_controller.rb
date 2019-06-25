class AuthorsController < ApplicationController
  def destroy
    Author.find(params[:id]).destroy
    flash[:notice] = 'Author has been deleted.'
    redirect_to admin_authors_path
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end
end
