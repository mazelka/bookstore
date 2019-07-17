require 'rails_helper'

module Features
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

  def search_by_name(name)
    within('#filters_sidebar_section') do
      find('#q_name').set(name)
      click_button 'Filter'
    end
  end

  def search_order_by_customer_name(first_name)
    within('#filters_sidebar_section') do
      select(first_name, from: 'q_customer_id')
      click_button 'Filter'
    end
  end
end
