require 'rails_helper'

describe 'carts', type: :feature do
  context 'empty cart' do
    it 'does not have added books on session start' do
      visit '/cart'
      expect(page).to have_selector('.shop-quantity', text: '0')
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
      visit '/cart'
      expect(page).to have_content(book.title)
    end

    it 'from home page' do
      visit '/books'
      page.find('.add-to-cart').click
      visit '/cart'
      expect(page).to have_content(book.title)
    end

    it 'from home page' do
      visit "/books/#{book.id}"
      page.find_button(text: 'Add to Cart').click
      visit '/cart'
      expect(page).to have_content(book.title)
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
      visit '/cart'
      page.find('.increase').click
      expect(page).to have_selector(".quantity-input[value='2']")
    end

    it 'decrease' do
      visit '/books'
      page.find('.add-to-cart').click
      visit '/cart'
      page.find('.decrease').click
      expect(page).to have_selector(".quantity-input[value='1']")
    end
  end
end
