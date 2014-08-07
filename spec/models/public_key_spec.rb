require 'spec_helper'

describe PublicKey, type: :model do
  it { should validate_presence_of(:data) }
  it { should validate_presence_of(:user_id) }
end
