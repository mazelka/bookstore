require 'rails_helper'

describe 'Author', type: :feature do
  let(:author) { create(:author, first_name: 'WithBook') }
  let(:author_without_book) { create(:author) }
  let(:book) { create(:book, author: author) }

  before :each do
    author
    author_without_book
    book
    sign_in
  end

  it 'visits authors page' do
    visit '/admin/authors'
    expect(page).to have_content('Authors')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_authors')
  end

  it 'creates new author' do
    visit '/admin/authors/new'
    within('.inputs') do
      find('#author_first_name').set('Dariia')
      find('#author_last_name').set('Dontsova')
      find('#author_biography').set(FFaker::BaconIpsum.paragraph)
    end
    click_button 'Create Author'
    expect(page).to have_content 'Author was successfully created.'
  end

  it 'edits existed author' do
    visit 'admin/authors'
    search_author_by_first_name(author_without_book.first_name)
    click_link 'Edit'
    within('.inputs') do
      find('#author_first_name').set('Stephen')
      find('#author_last_name').set('King')
      find('#author_biography').set(FFaker::BaconIpsum.paragraph)
    end
    click_button 'Update Author'
    expect(page).to have_content('Author was successfully updated.')
    expect(page).to have_content('Stephen')
  end

  it 'deletes author without associated books' do
    visit 'admin/authors'
    authors_before_delete = page.all('#index_table_authors tbody tr').length
    search_author_by_first_name(author_without_book.first_name)
    click_link 'Delete'
    authors_after_delete = page.all('#index_table_authors tbody tr').length
    expect(authors_after_delete).to eq(authors_before_delete - 1)
    expect(page).to have_content('Author has been deleted.')
  end

  it 'deletes author with associated books' do
    visit 'admin/authors'
    search_author_by_first_name(author.first_name)
    click_link 'Delete'
    expect(page).to have_content('Author has been deleted.')
  end
end
