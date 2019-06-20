require 'rails_helper'

describe 'Review', type: :feature do
  let(:review) { create(:review) }
  before :each do
    review
    sign_in
  end

  it 'visits reviews page' do
    visit '/admin/reviews'
    expect(page).to have_content('Reviews')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_reviews')
  end

  it 'opens existed review' do
    visit '/admin/reviews'
    search_by_title(review.title)
    click_link 'View'
    expect(page).to have_content(review.title)
    expect(page).to have_no_link(review.text)
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
