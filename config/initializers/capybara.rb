if Rails.env.development? || Rails.env.test?
  Capybara.default_selector = :css
end
