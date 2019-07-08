class AuthorsController < ApplicationController
  def destroy
    Author.find(params[:id]).destroy
    flash[:notice] = t('.admin.messages.author_deleted')
    redirect_to admin_authors_path
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end
end
