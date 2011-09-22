require 'spec_helper'

describe Section do
  context "#to_param" do
    subject { Factory(:section) }
    it "returns the id and parameterized course name" do
      subject.to_param.should == "#{subject.id}-#{subject.course_name.parameterize}"
    end
  end

  context "#seats_available" do
    let(:course) { Factory(:course, :maximum_students => 8) }
    context "with no seats available set" do
      subject { Factory(:section, :course => course) }
      it "returns course's maximum students" do
        subject.seats_available.should == 8
      end
    end

    context "with seats available set" do
      subject { Factory(:section, :course => course, :seats_available => 12) }
      it "returns section's seats available" do
        subject.seats_available.should == 12
      end
    end
  end
end

