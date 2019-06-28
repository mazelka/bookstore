class CheckoutController < ApplicationController
  include Wicked::Wizard
  steps :login, :shipping_address, :billing_address, :credit_card, :confirmation
end
