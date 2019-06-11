require 'spec_helper'
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:count) }
  it { should validate_length_of(:title) }
  it { should have_many(:reviews) }
  it { should belong_to(:author) }
  it { should belong_to(:category) }
end
