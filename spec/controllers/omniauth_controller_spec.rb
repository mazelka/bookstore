require 'rails_helper'
include ControllerMacros

describe Customer::OmniauthCallbacksController do
  before { @controller = Customer::OmniauthCallbacksController.new }
  it 'successful sign_up with a facebook' do
    valid_facebook_login_setup
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    get 'facebook'
    expect(subject.current_customer).to be_present
    expect(flash[:notice]).to include('Successfully signed in!')
  end

  it 'failed to sign_up with a facebook user without email' do
    no_email_facebook_login_setup
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    get 'facebook'
    expect(subject.current_customer).to be_nil
    expect(session['devise.customer_attributes']).to include({ 'email' => '' })
  end
end
