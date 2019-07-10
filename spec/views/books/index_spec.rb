require 'rails_helper'

describe 'books/index.html.haml', type: :feature do
  let(:book) { create(:book) }
  before :each do
    book
  end

  it 'shows All books link' do
    visit '/books'
    expect(page).to have_selector(:link, '', href: '/books')
  end

  it 'shows book with details' do
    visit '/books'
    expect(page).to have_content(book.title)
    expect(page).to have_selector('p', text: "$#{book.price / 100}")
    expect(page).to have_selector('p', text: "#{book.author.first_name} #{book.author.last_name}")
  end

  it 'does not show view more for 1 book' do
    visit '/books'
    expect(page).to have_no_selector(:link, 'View More')
  end

  it 'has options for sorting' do
    visit '/books'
    expect(page).to have_selector(:link, 'Newest first')
    expect(page).to have_selector(:link, 'Popular first')
    expect(page).to have_selector(:link, 'Price: Low to high')
    expect(page).to have_selector(:link, 'Price: High to low')
  end

  context 'view more' do
    let!(:book) { create_list(:book, 13) }

    it 'shows for at least 13 books' do
      visit '/books'
      expect(page).to have_selector(:link, 'View More')
    end
  end
end
