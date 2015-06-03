require "spec_helper"

describe NullAttempt do
  describe "#confidence" do
    it "should be a 0 to signify the user not having attempted" do
      expect(NullAttempt.new.confidence).to eq(0)
    end
  end

  describe "#low_confidence?" do
    it "returns false" do
      expect(NullAttempt.new.low_confidence?).to be_falsey
    end
  end
end
