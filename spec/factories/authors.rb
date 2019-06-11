FactoryBot.define do
  factory :author do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    biography { FFaker::BaconIpsum.sentence }
  end

  # after(:create) do |author|
  #   create_list(:book, 5, author: author)
  # end

  # factory :category do
  #   title { FFaker::BaconIpsum.word }
  # end

  # factory :book do
  #   category
  #   title { FFaker::Book.title }
  #   price { Random.rand(40.0).floor(2) }
  #   count { Random.rand(10) }
  # end
end
