require "spec_helper"

describe NullAttempt do
  describe "#confidence" do
    it "should be a '-' to signify the user not having attempted" do
      expect(NullAttempt.new.confidence).to eq("-")
    end
  end
end
