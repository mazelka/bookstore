require 'rails_helper'

describe 'carts', type: :feature do
  context 'empty cart' do
    it 'does not have added books on session start' do
      visit '/carts'
      expect(page).to have_selector('.shop-quantity', text: '0')
      expect(page).to have_content('You don`t have added books. Go and find something in Catalog!')
    end
  end

  context 'adds book' do
    let(:book) { create(:book) }
    before :each do
      book
    end

    it 'from home page' do
      visit '/'
      page.find('.add-to-cart').click
      visit '/carts'
      expect(page).to have_content(book.title)
    end

    it 'from books page' do
      visit '/books'
      page.find('.add-to-cart').click
      visit '/carts'
      expect(page).to have_content(book.title)
    end

    it 'from book show page' do
      visit "/books/#{book.id}"
      page.find_button(text: 'Add to Cart').click
      visit '/carts'
      expect(page).to have_content(book.title)
    end

    it 'several books from show page' do
      visit "/books/#{book.id}"
      page.find('.quantity-input').set('3')
      page.find_button(text: 'Add to Cart').click
      visit '/carts'
      expect(page).to have_content(book.title)
      expect(page).to have_selector(".quantity-input[value='3']")
    end
  end

  context 'change quantity' do
    let(:book) { create(:book) }
    before :each do
      book
      visit '/books'
      page.find('.add-to-cart').click
    end

    it 'increase' do
      visit '/carts'
      page.find('.increase').click
      expect(page).to have_selector(".quantity-input[value='2']")
    end

    it 'decrease' do
      visit '/books'
      page.find('.add-to-cart').click
      visit '/carts'
      page.find('.decrease').click
      expect(page).to have_selector(".quantity-input[value='1']")
    end

    it 'cannot decrease from 1' do
      visit '/carts'
      expect(page).to have_no_selector('.decrease')
      expect(page).to have_selector(".quantity-input[value='1']")
    end
  end

  context 'removes book' do
    let(:book) { create(:book) }
    before :each do
      book
      visit '/books'
      page.find('.add-to-cart').click
    end

    it 'clicks remove' do
      visit '/carts'
      page.find('.general-cart-close').click
      expect(page).to have_no_content(book.title)
      expect(page).to have_selector('.shop-quantity', text: '0')
    end
  end

  context 'apply coupon' do
    let(:book) { create(:book) }
    let(:coupon) { create(:coupon) }
    before :each do
      coupon
      book
      visit '/books'
      page.find('.add-to-cart').click
    end

    it 'coupon form is shown' do
      visit '/carts'
      expect(page).to have_selector('.general-input-group')
    end

    it 'valid coupon' do
      visit '/carts'
      page.find('.coupon-input').set(coupon.name)
      page.find_button(text: 'Apply Coupon').click
      expect(page).to have_no_selector('.general-input-group')
      expect(page).to have_content('Your coupon is applied!')
    end

    it 'not valid coupon' do
      visit '/carts'
      page.find('.coupon-input').set('not valid')
      page.find_button(text: 'Apply Coupon').click
      expect(page).to have_selector('.general-input-group')
      expect(page).to have_content('Sorry, we don`t have this coupon')
    end
  end
end
