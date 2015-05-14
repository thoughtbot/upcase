require "rails_helper"

describe Attempt do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:confidence) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
