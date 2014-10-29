require "spec_helper"

describe Unstarted do
  it "has the state 'Unstarted'" do
    expect(Unstarted.new.state).to eq "Unstarted"
  end
end
