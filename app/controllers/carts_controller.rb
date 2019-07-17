require_relative '../services/cart_details'

class CartsController < ApplicationController
  after_action :cart_to_session, except: [:show_cart, :apply_coupon]

  def add_to_cart
    add_book(params[:id], params[:quantity])
    flash[:notice] = t('carts.cart.added_to_cart')
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

  def index
    session.delete(:order_id)
    @coupon = get_coupon_discount(session[:coupon_id]) || 0
    @cart_details = CartDetails.new(@cart, @coupon)
    render 'cart'
  end

  def remove_item
    current_item = find_in_cart(params[:id].to_i)
    @cart.delete(current_item)
    redirect_back fallback_location: root_path
  end

  def increase_quantity
    current_item = find_in_cart(params[:book_id].to_i)
    current_item[:quantity] += 1
    redirect_back fallback_location: root_path
  end

  def decrease_quantity
    @cart = session[:cart]
    current_item = find_in_cart(params[:book_id].to_i)
    current_item[:quantity] == 1 ? current_item[:quantity] : current_item[:quantity] -= 1
    redirect_back fallback_location: root_path
  end

  def apply_coupon
    if coupon_exists?(params[:coupon])
      save_in_session_coupon_id(params[:coupon])
      @coupon = get_coupon_discount(coupon_id)
      flash[:notice] = t('carts.cart.coupon_applied')
      @cart_details = CartDetails.new(@cart, @coupon)
    else
      flash[:notice] = t('carts.cart.invalid_coupon')
    end
    redirect_back fallback_location: root_path
  end

  private

  def find_in_cart(id)
    @cart.find { |item| item[:book_id] == id }
  end

  def cart_to_session
    session[:cart] = @cart
  end

  def get_coupon_discount(id)
    session[:coupon_id].nil? ? 0 : Coupon.find(id).discount
  end

  def coupon_exists?(name)
    !Coupon.all.find_by(name: name).nil?
  end

  def save_in_session_coupon_id(name)
    @coupon = Coupon.find_by(name: name)&.id
    session[:coupon_id] = @coupon
  end

  def coupon_id
    session[:coupon_id]
  end
end
