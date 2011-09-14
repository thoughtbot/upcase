require 'spec_helper'

describe Section do
  context "#to_param" do
    subject { Factory(:section) }
    it "returns the id and parameterized course name" do
      subject.to_param.should == "#{subject.id}-#{subject.course_name.parameterize}"
    end
  end
end

