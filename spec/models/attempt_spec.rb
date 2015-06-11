require "rails_helper"

describe Attempt do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:flashcard_id) }
  it { should validate_presence_of(:confidence) }

  it { should belong_to(:flashcard) }
  it { should belong_to(:user) }

  describe "#low_confidence?" do
    context "when the confidence is low" do
      it "returns true" do
        attempt = build_stubbed(:attempt, confidence: Attempt::LOW_CONFIDENCE)

        result = attempt.low_confidence?

        expect(result).to be_truthy
      end
    end

    context "when the confidence is high" do
      it "returns false" do
        attempt = build_stubbed(:attempt, confidence: Attempt::HIGH_CONFIDENCE)

        result = attempt.low_confidence?

        expect(result).to be_falsey
      end
    end
  end
end
