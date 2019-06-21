require 'rails_helper'

describe 'home/index.html.haml', type: :view do
  let(:book) { create(:book) }
  before :each do
    assign(:latest_books, [book])
    assign(:bestsellers, [book])
  end

  it 'shows book attributes' do
    visit '/'
    expect(page).to have_content(book.title)
    expect(page).to have_selector('p', text: "$#{book.price / 100}")
    expect(page).to have_selector('p', text: "#{book.author.first_name} #{book.author.last_name}")
  end

  it 'opens book show page' do
    visit '/'
    page.find('.show-book').click
    expect(response).to render_template(:show)
  end
end
