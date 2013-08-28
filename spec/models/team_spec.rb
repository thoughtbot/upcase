require 'spec_helper'

describe Team do
  it { should belong_to(:team_plan) }
  it { should have_many(:subscriptions) }
  it { should have_many(:users).through(:subscriptions) }
  it { should validate_presence_of(:name) }
end
