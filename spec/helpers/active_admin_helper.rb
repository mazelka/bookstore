module Features
  def preconditions
    AdminUser.create(email: 'admin@example.com', password: 'password')
    Author.create(first_name: 'Janna', last_name: 'Aguzarova')
    Category.create(title: 'Horror')
    Book.create(title: 'Wonderland', price: 999, inventory: 1, author_id: 1, category_id: 1)
  end

  def sign_in
    visit '/admin/login'
    within('#login') do
      fill_in 'Email', with: 'admin@example.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Login'
  end
end
