require 'rails_helper'

describe 'Book', type: :feature do
  let(:book) { create(:book) }
  before :each do
    book
    sign_in
  end

  it 'visits books page' do
    visit '/admin/books'
    expect(page).to have_content('Books')
    expect(page).to have_selector('#filters_sidebar_section')
    expect(page).to have_selector('#index_table_books')
  end

  it 'creates new book without cover' do
    visit '/admin/books/new'
    within('.inputs') do
      find('#book_title').set('test')
      find('#book_price').set('99')
      find('#book_inventory').set('9')
      find('#book_author_id > option:nth-child(2)').select_option
      find('#book_category_id > option:nth-child(2)').select_option
    end
    click_button 'Save'
    expect(page).to have_content 'Book was successfully created.'
  end

  it 'edits existed book' do
    visit '/admin/books'
    search_by_title(book.title)
    click_link 'Edit'
    within('.inputs') do
      find('#book_title').set('Edited Wonderland')
      find('#book_price').set('9.12')
      find('#book_description').set(FFaker::Book.description)
      find('#book_inventory').set('1')
      find('#book_author_id > option:nth-child(2)').select_option
      find('#book_category_id > option:nth-child(2)').select_option
    end
    click_button 'Save'
    expect(page).to have_content('Book was successfully updated.')
    expect(page).to have_content('Edited Wonderland')
    expect(page).to have_content('9.12')
  end

  it 'adds cover to existed book' do
    visit '/admin/books'
    search_by_title(book.title)
    click_link 'Edit'
    within('.inputs') do
      attach_file('book_cover', './spec/test_files/2017-07-24 12.22.44.jpg')
    end
    click_button 'Save'
    expect(page).to have_content('Book was successfully updated.')
    expect(page).to have_selector("img[src=\"/uploads/book/cover/#{book.id}/thumb_2017-07-24_12.22.44.jpg\"]")
  end

  it 'deletes book' do
    visit 'admin/books'
    books_before_delete = page.all('#index_table_books tbody tr').length
    search_by_title(book.title)
    click_link 'Delete'
    books_after_delete = page.all('#index_table_books tbody tr').length
    expect(books_after_delete).to eq(books_before_delete - 1)
    expect(page).to have_content('Book was successfully destroyed.')
  end
end
