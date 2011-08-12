require 'spec_helper'

describe Course do
  it { should belong_to(:audience) }
end
