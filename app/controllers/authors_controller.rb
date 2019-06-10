class AuthorsController < InheritedResources::Base
  def index
    Author.all
  end

  def create(first_name, last_name)
    @author = Author.new(first_name, last_name)
    if @author.valid?
      @author.save
    end
  end

  def save
    save
  end

  def show(id)
    Author.find(id)
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end
end
