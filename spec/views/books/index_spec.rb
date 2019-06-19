require 'rails_helper'

describe 'books/index.html.haml', type: :view do
  let(:book) { create(:book) }
  before :each do
    book
    assign(:books, book)
  end

  # it 'shows total number of books' do
  #   p assigns(:books)
  #   visit '/books'
  #   expect(page).to have_content('a', text: 'All')
  # end
end
