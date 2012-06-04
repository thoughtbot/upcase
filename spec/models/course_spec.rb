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
end
