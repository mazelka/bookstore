FactoryBot.define do
  factory :author do
    first_name { FFaker::String.from_regexp(/\A[a-zA-Z]{49}\z/) }
    last_name { FFaker::String.from_regexp(/\A[a-zA-Z]{49}\z/) }
    biography { FFaker::BaconIpsum.sentence }
  end
end
