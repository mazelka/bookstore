require 'rails_helper'
include Authentication

describe 'sign_up', type: :feature do
  context 'with valid info' do
    let(:customer) { build(:customer) }
    it 'successful sign_up' do
      visit '/customers/sign_up'
      page.find('#email').set(customer.email)
      page.find('#first_name').set(customer.first_name)
      page.find('#last_name').set(customer.last_name)
      page.find('#password').set(customer.password)
      page.find('#submit').click
      expect(current_path).to eql(root_path)
      expect(page).to have_content('You have signed up successfully')
    end
  end

  context 'with invalid info' do
    let(:customer) { build(:customer) }
    it 'empty email' do
      visit '/customers/sign_up'
      page.find('#email').set('')
      page.find('#first_name').set(customer.first_name)
      page.find('#last_name').set(customer.last_name)
      page.find('#password').set(customer.password)
      page.find('#submit').click
      expect(page).to have_content("Email can't be blank")
    end

    it 'empty first name' do
      visit '/customers/sign_up'
      page.find('#email').set(customer.email)
      page.find('#first_name').set('')
      page.find('#last_name').set(customer.last_name)
      page.find('#password').set(customer.password)
      page.find('#password').set(customer.password)
      page.find('#submit').click
      expect(page).to have_content("First name can't be blank")
    end

    it 'empty last name' do
      visit '/customers/sign_up'
      page.find('#email').set(customer.email)
      page.find('#first_name').set(customer.first_name)
      page.find('#last_name').set('')
      page.find('#password').set(customer.password)
      page.find('#password').set(customer.password)
      page.find('#submit').click
      expect(page).to have_content("Last name can't be blank")
    end

    it 'link to sign_up' do
      visit '/customers/sign_up'
      page.find('.log-in-link').click
      expect(current_path).to eq(new_customer_session_path)
    end

    it 'link to forgot password' do
      visit '/customers/sign_up'
      page.find('.forgot-password').click
      expect(current_path).to eq(new_customer_password_path)
    end
  end
end
