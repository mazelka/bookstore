require 'rails_helper'

describe 'Review', type: :feature do
  before :all do
    preconditions
    Customer.create(first_name: 'Reader', last_name: 'One', email: 'email@test.com', password: 'Passw0rd')
    Review.create(title: 'Excelent choice', text: FFaker::String.from_regexp(/\A[a-zA-Z0-9]{200}\z/), customer_id: 1, book_id: 1)
  end
  before :each do
    sign_in
  end

  it 'visits reviews page' do
    visit '/admin/reviews'
    expect(page).to have_content('Reviews')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_reviews')
  end

  it 'opens existed review' do
    visit '/admin/reviews/1'
    expect(page).to have_content('Excelent choice')
    expect(page).to have_no_link('Delete')
    expect(page).to have_no_link('Edit')
  end

  it 'cannot create new review' do
    visit '/admin/reviews'
    expect(page).to have_content('Reviews')
    expect(page).to have_no_link('Delete')
    expect(page).to have_no_link('Edit')
    expect(page).to have_no_link('New Review')
  end
end
