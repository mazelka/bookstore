require_relative '../services/cart_details'

class CartsController < ApplicationController
  after_action :cart_to_session, except: [:show_cart, :apply_coupon]

  COUPON = 'RUBY'
  DISCOUNT = 100

  def add_to_cart
    add_book(params[:id], params[:quantity])
    flash[:notice] = 'Added to Cart!'
    redirect_to book_path(params[:id])
  end

  def add_book(book_id, new_quantity)
    current_item = find_in_cart(book_id.to_i)
    if current_item
      current_item[:quantity] += new_quantity.to_i
    else
      book = Book.find(book_id)
      item = { book_id: book.id, title: book.title, price: book.price, url: book.cover_url, quantity: new_quantity.to_i }
      @cart << item
    end
  end

  def show_cart
    @coupon = session[:coupon] || 0
    @cart_details = CartDetails.new(@cart, @coupon)
    render 'cart'
  end

  def remove_item
    current_item = find_in_cart(params[:id].to_i)
    @cart.delete(current_item)
    redirect_to cart_path
  end

  def increase_quantity
    current_item = find_in_cart(params[:book_id].to_i)
    current_item[:quantity] += 1
    redirect_to cart_path
  end

  def decrease_quantity
    @cart = session[:cart]
    current_item = find_in_cart(params[:book_id].to_i)
    current_item[:quantity] == 1 ? current_item[:quantity] : current_item[:quantity] -= 1
    redirect_to cart_path
  end

  def apply_coupon
    if params[:coupon] == COUPON
      @coupon = DISCOUNT
      session[:coupon] = @coupon
      flash[:notice] = 'Your coupon is applied!'
      @cart_details = CartDetails.new(@cart, @coupon)
      render 'cart'
    else
      flash[:notice] = 'Sorry, we don`t have this coupon'
      redirect_to cart_path
    end
  end

  private

  def find_in_cart(id)
    @cart.find { |item| item[:book_id] == id }
  end

  def cart_to_session
    session[:cart] = @cart
  end
end