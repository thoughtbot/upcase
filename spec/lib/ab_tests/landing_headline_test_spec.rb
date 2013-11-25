require "spec_helper"

describe AbTests::LandingHeadlineTest do
  describe '#setup' do
    subject { AbTests::LandingHeadlineTest.new(stub, stub, stub) }

    it "returns the original headline by default" do
      subject.stubs(ab_test: 'orig')
      expect(subject.setup).to match(/Become an expert/)
    end

    it "returns variations on demand" do
      subject.stubs(ab_test: 'v1')
      expect(subject.setup).to match(/Learn to code so you can/)
    end
  end

  describe '#finish' do
    subject { AbTests::LandingHeadlineTest.new(stub, stub, stub) }

    it "should delegate to Split#finished" do
      subject.stubs(:finished)
      subject.finish
      expect(subject).to have_received(:finished).with(subject.test_name)
    end
  end
end
