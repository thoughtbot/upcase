require "spec_helper"

describe NullAttempt do
  describe "#confidence" do
    it "should be a 0 to signify the user not having attempted" do
      expect(NullAttempt.new.confidence).to eq(0)
    end
  end
end
