require 'spec_helper'
require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:text) }
  it { should validate_length_of(:title) }
  it { should validate_length_of(:text) }
  it { should allow_value('Maashaaa').for(:title) }
  it { should allow_value('123').for(:title) }
  it { should allow_value("!#$%&'*+-\/=?^_`{|}~").for(:title) }
  it { should allow_value('Kaashaaa').for(:text) }
  it { should allow_value('123').for(:text) }
  it { should allow_value("!#$%&'*+-\/=?^_`{|}~").for(:text) }
  it { should belong_to(:book) }
  it { should belong_to(:customer) }

  context 'validations' do
    
  end
end
