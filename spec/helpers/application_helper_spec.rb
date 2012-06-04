require 'spec_helper'

describe ApplicationHelper do
  context "#full_title" do
    it "returns the base title when no title is given" do
      helper.full_title("").should == "thoughtbot workshops"
    end

    it "returns a full title when title is provided" do
      helper.full_title("ruby").should == "ruby | thoughtbot workshops"
    end
  end
end
