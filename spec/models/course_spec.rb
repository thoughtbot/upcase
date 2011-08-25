require 'spec_helper'

describe Course do
  it { should belong_to(:audience) }
  it { should validate_presence_of(:audience_id) }
end
