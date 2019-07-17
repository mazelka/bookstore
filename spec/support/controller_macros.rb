module ControllerMacros
  def customer_set_up_devise
    @request.env['devise.mapping'] = Devise.mappings[:customer]
  end

  def valid_facebook_login_setup
    @request.env['devise.mapping'] = Devise.mappings[:customer]
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(valid_info)
    end
  end

  def no_email_facebook_login_setup
    @request.env['devise.mapping'] = Devise.mappings[:customer]
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(info_without_email)
    end
  end

  def valid_info
    {
      provider: 'facebook',
      uid: '123545',
      info: {
        first_name: 'Gaius',
        last_name: 'Baltar',
        email: 'test@example.com',
      },
      credentials: {
        token: '123456',
        expires_at: Time.now + 1.week,
      },
    }
  end

  def info_without_email
    {
      provider: 'facebook',
      uid: '123545',
      info: {
        first_name: 'Gaius',
        last_name: 'Baltar',
      },
      credentials: {
        token: '123456',
        expires_at: Time.now + 1.week,
      },
    }
  end
end
