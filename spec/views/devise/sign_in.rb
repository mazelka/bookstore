require 'rails_helper'
include Authentication

describe 'sign_in', type: :feature do
  let(:customer) { create(:customer) }
  before :each do
    customer
  end

  it 'login with valid credentials' do
    visit '/customers/sign_in'
    page.find('#email').set(customer.email)
    page.find('#password').set(customer.password)
    page.find('#submit').click
    expect(current_path).to eql(root_path)
    expect(page).to have_content('Signed in successfully')
  end

  it 'login with incorrect password' do
    visit '/customers/sign_in'
    page.find('#email').set(customer.email)
    page.find('#password').set('incorrect_password')
    page.find('#submit').click
    expect(page).to have_content('Invalid Email or password')
  end

  it 'login with incorrect email' do
    visit '/customers/sign_in'
    page.find('#email').set('sdas@qasd.com')
    page.find('#password').set(customer.password)
    page.find('#submit').click
    expect(page).to have_content('Invalid Email or password')
  end

  it 'link to sign_up' do
    visit '/customers/sign_in'
    page.find('.sign-up-link').click
    expect(current_path).to eq(new_customer_registration_path)
  end

  it 'link to forgot password' do
    visit '/customers/sign_in'
    page.find('.forgot-password').click
    expect(current_path).to eq(new_customer_password_path)
  end
end
