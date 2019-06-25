require 'rails_helper'
include Authentication

describe 'reviews', type: :feature do
  context 'anonymous user' do
    let(:book) { create(:book) }
    let(:unprocessed_review) { create(:review, book: book) }
    let(:rejected_review) { create(:review, book: book, aasm_state: 'rejected') }
    let(:reviews) { create_list(:review, 3, aasm_state: 'approved', book: book) }
    before :each do
      book
    end

    it 'sees reviews if exist' do
      reviews
      visit "/books/#{book.id}"
      expect(page).to have_content('Reviews (3)')
    end

    it 'sees only approved reviews' do
      reviews
      unprocessed_review
      rejected_review
      visit "/books/#{book.id}"
      expect(page).to have_content('Reviews (3)')
    end

    it 'cannot create new review' do
      reviews
      visit "/books/#{book.id}"
      expect(page).to have_no_content('Write a Review')
      expect(page).to have_no_selector('button', text: 'Write a Review')
    end
  end

  context 'logged user' do
    let(:book) { create(:book) }
    let(:customer) { create(:customer) }
    before :each do
      book
      customer_sign_in
    end

    it 'sees form to create new review' do
      visit "/books/#{book.id}"
      expect(page).to have_content('Write a Review')
      expect(page).to have_selector('button', text: 'Post')
    end

    it 'creates new review' do
      visit "/books/#{book.id}"
      page.find('#title').set('sometext')
      page.find('#review').set('sometext-review')
      click_button 'Post'
      expect(page).to have_content('Review was sent to approve!')
    end

    it 'cannot see own unprocessed review' do
      visit "/books/#{book.id}"
      page.find('#title').set('sometext')
      page.find('#review').set('sometext-review')
      click_button 'Post'
      expect(page).to have_no_content('sometext')
    end

    it ' sees errors if title is missed' do
      visit "/books/#{book.id}"
      page.find('#title').set('')
      page.find('#review').set('sometext-review')
      click_button 'Post'
      expect(page).to have_content("Title can't be blank Title is too short (minimum is 1 character) Title is invalid")
    end

    it ' sees errors if text is missed' do
      visit "/books/#{book.id}"
      page.find('#title').set('sometext')
      page.find('#review').set('')
      click_button 'Post'
      expect(page).to have_content("Text can't be blank Text is too short (minimum is 1 character) Text is invalid")
    end
  end
end
