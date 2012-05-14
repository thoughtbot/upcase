require 'spec_helper'

describe Teacher do
  context ".by_name" do
    let!(:bob) { create(:teacher, :name => "Bob Doe") }
    let!(:albert) { create(:teacher, :name => "Albert Doe") }
    subject { Teacher.by_name }

    it "sorts the result by name" do
      subject.should == [albert, bob]
    end
  end
end
