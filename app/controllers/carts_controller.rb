class CartsController < ApplicationController
  COUPON = 'RUBY'
  DISCOUNT = 100

  def add_to_cart
    @cart = find_order
    add_book(params[:id], params[:quantity])
    flash[:notice] = 'Added to Cart!'
    redirect_to book_path(params[:id])
  end

  def add_book(book_id, new_quantity)
    current_item = @cart.find { |item| item[:book_id] == book_id.to_i }
    if current_item
      current_item[:quantity] += new_quantity.to_i
    else
      book = Book.find(book_id)
      item = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: new_quantity.to_i }
      @cart << item
    end
    session[:cart] = @cart
  end

  def show_cart
    @coupon = session[:coupon] || 0
    @cart = session[:cart] || []
    render 'cart'
  end

  def remove_item
    @cart = session[:cart]
    current_item = @cart.find { |item| item[:book_id] == params[:id].to_i }
    @cart.delete(current_item)
    session[:cart] = @cart
    redirect_to cart_path
  end

  def increase_quantity
    @cart = session[:cart]
    current_item = @cart.find { |item| item[:book_id] == params[:book_id].to_i }
    current_item[:quantity] += 1
    session[:cart] = @cart
    redirect_to cart_path
  end

  def decrease_quantity
    @cart = session[:cart]
    current_item = @cart.find { |item| item[:book_id] == params[:book_id].to_i }
    current_item[:quantity] -= 1
    session[:cart] = @cart
    redirect_to cart_path
  end

  def apply_coupon
    if params[:coupon] == COUPON
      @cart = session[:cart]
      @coupon = DISCOUNT
      session[:coupon] = @coupon
      render 'cart', locals: { resorce: @coupon }
    else
      flash[:notice] = 'Sorry, we don`t have this coupon'
      redirect_to cart_path
    end
  end

  def cart_params
    params.permit(:coupon, :last_name, :biography)
  end
end
