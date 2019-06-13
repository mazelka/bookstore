FactoryBot.define do
  factory :book do
    author
    category
    cover { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/test_files/2017-07-24 12.22.44.jpg'))) }
    title { FFaker::Book.title }
    price { Random.rand(40) }
    inventory { Random.rand(10) }
  end
end
