require 'rails_helper'

module Features
  def preconditions
    AdminUser.create(email: 'admin@example.com', password: 'password')
    Author.create(first_name: 'Janna', last_name: 'Aguzarova')
    Category.create(title: 'Horror')
    Book.create(title: 'Wonderland', price: 999, inventory: 1, author_id: 1, category_id: 1)
  end

  def sign_in
    create(:admin_user)
    visit '/admin/login'
    within('#login') do
      fill_in 'Email', with: 'admin@example.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Login'
  end

  def search_author_by_first_name(first_name)
    within('#filters_sidebar_section') do
      find('#q_first_name').set(first_name)
      click_button 'Filter'
    end
  end

  def search_by_title(title)
    within('#filters_sidebar_section') do
      find('#q_title').set(title)
      click_button 'Filter'
    end
  end
end
