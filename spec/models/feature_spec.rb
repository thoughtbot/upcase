require 'spec_helper'

describe Feature do
  it { should belong_to(:plan) }
end
