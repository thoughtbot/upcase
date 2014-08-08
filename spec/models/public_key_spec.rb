require "rails_helper"

describe PublicKey do
  it { should validate_presence_of(:data) }
  it { should validate_presence_of(:user_id) }
end
