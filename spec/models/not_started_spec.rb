require "spec_helper"

describe NotStarted do
  it "has the state 'Not Started'" do
    expect(NotStarted.new.state).to eq "Not Started"
  end
end
