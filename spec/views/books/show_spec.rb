require 'rails_helper'

describe 'books/show.html.haml', type: :feature do
  context 'attributes' do
    let(:book) { create(:book) }
    before :each do
      book
    end

    it 'shows book details' do
      visit "/books/#{book.id}"
      expect(page).to have_content(book.title)
      expect(page).to have_content("#{book.author.first_name} #{book.author.last_name}")
      expect(page).to have_content("$#{book.price / 100}")
    end

    it 'shows book cover' do
      visit "/books/#{book.id}"
      expect(page).to have_selector("img[src = \"/uploads/book/cover/#{book.id}/2017-07-24_12.22.44.jpg\"]")
    end
  end
  context 'description' do
    description = FFaker::BaconIpsum.paragraphs.join(' ')
    let!(:book) { create(:book, description: description) }

    it 'shows description' do
      visit "/books/#{book.id}"
      expect(page).to have_selector('.book-description', text: book.description)
    end
  end

  context 'navigating' do
    let!(:book) { create(:book) }

    it 'navigates to back' do
      visit '/books'
      page.find('.show-book').click
      page.find('.general-back-link').click
      expect(page).to have_current_path('/books')
    end
  end
end
