require "rails_helper"

RSpec.describe ContentRecommendation do
  it { should belong_to(:user) }
  it { should belong_to(:recommendable) }
end
