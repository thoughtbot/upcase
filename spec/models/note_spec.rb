require 'spec_helper'

describe Note do
  context 'associations' do
    it { should belong_to(:user) }
  end
end
