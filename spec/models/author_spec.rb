require 'spec_helper'
require 'rails_helper'

require File.expand_path('../../../app/models/author.rb', __FILE__)
RSpec.describe Author, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:first_name) }
  it { should validate_length_of(:last_name) }
  it { should allow_value('Maashaaa').for(:first_name) }
  it { should allow_value('Kaashaaa').for(:last_name) }
  it { should have_many(:books) }
end
