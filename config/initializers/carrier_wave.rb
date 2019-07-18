require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.dropbox_access_token = ENV['ACCESS_TOKEN']
end
