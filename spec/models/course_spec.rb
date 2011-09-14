require 'spec_helper'

describe Course do
  it { should belong_to(:audience) }
  it { should validate_presence_of(:audience_id) }

  context "#to_param" do
    subject { Factory(:course) }
    it "returns the id and parameterized name" do
      subject.to_param.should == "#{subject.id}-#{subject.name.parameterize}"
    end
  end
end
