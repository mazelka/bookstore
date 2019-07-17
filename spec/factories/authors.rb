FactoryBot.define do
  factory :author do
    first_name { FFaker::Lorem.characters.gsub(/[0-9]/, '').slice(0, 49) }
    last_name { FFaker::Lorem.characters.gsub(/[0-9]/, '').slice(0, 49) }
    biography { FFaker::BaconIpsum.sentence }
  end
end
