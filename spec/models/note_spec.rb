require 'spec_helper'

describe Note do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:user_id) }
  end
end
