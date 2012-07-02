require 'spec_helper'

describe Course do
  it { should belong_to(:audience) }
  it { should validate_presence_of(:audience_id) }

  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  context "#to_param" do
    subject { create(:course) }
    it "returns the id and parameterized name" do
      subject.to_param.should == "#{subject.id}-#{subject.name.parameterize}"
    end
  end

  describe "#for_topic" do
    it "includes only courses for the given topic" do
      topic = FactoryGirl.create(:topic)
      in_topic = FactoryGirl.create(:course)
      topic.courses << in_topic
      not_in_topic = FactoryGirl.create(:course)

      Course.for_topic(topic).should include in_topic
      Course.for_topic(topic).should_not include not_in_topic
    end
  end
end
