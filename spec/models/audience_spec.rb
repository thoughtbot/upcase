require 'spec_helper'

describe Audience, "associations" do
  it { should have_many(:courses) }
end

describe Audience, "validations" do
  it { should validate_presence_of(:name) }
end
