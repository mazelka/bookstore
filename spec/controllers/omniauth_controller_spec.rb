require 'rails_helper'
include ControllerMacros

describe Customer::OmniauthCallbacksController do
  before { @controller = Customer::OmniauthCallbacksController.new }
  context 'successful sign_up with a facebook' do
    before do
      valid_facebook_login_setup
      @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      get 'facebook'
    end
    it 'customer sign_up' do
      expect(subject.current_customer).to be_present
      expect(flash[:notice]).to include('Successfully signed in!')
    end
  end

  context 'failed sign_up with facebook' do
    before do
      no_email_facebook_login_setup
      @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      get 'facebook'
    end
    it 'user without email' do
      expect(subject.current_customer).to be_nil
      expect(session['devise.customer_attributes']).to include({ 'email' => '' })
    end
  end
end
