# require 'rails_helper'

# describe 'the signin process', type: :feature do
#   before :all do
#     AdminUser.create(email: 'admin@example.com', password: 'password')
#     Author.create(first_name: 'Janna', last_name: 'Aguzarova')
#     Category.create(title: 'Horror')
#     Book.create(title: 'Wonderland', price: 999, inventory: 1, author_id: 1, category_id: 1)
#   end

#   it 'creates new book' do
#     visit '/admin/login'
#     within('#login') do
#       fill_in 'Email', with: 'admin@example.com'
#       fill_in 'Password', with: 'password'
#     end
#     click_button 'Login'
#     visit '/admin/books/new'
#     within('.inputs') do
#       find(:css, '#book_title').set('test')
#       find(:css, '#book_price').set('99')
#       find(:css, '#book_inventory').set('9')
#       first('#book_author_id option').select_option
#       first('#book_category_id option').select_option
#     end
#     # save_and_open_page
#     click_button 'Save'
#     save_and_open_page
#     expect(page).to have_content 'Book was successfully created.'
#   end
# end
