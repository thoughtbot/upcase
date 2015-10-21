require "rails_helper"

describe Collaboration do
  it { should belong_to(:repository) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:repository_id) }
end
