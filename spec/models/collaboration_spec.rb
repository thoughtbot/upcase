require "rails_helper"

describe Collaboration do
  it { should belong_to(:repository) }
  it { should belong_to(:user) }
end
