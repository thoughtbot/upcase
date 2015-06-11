require "rails_helper"

describe FlashcardsNeedingReviewQuery do
  describe "#run" do
    it "returns flashcards whose last attempt had low confidence" do
      user = create(:user)
      low_confidence_flashcard = create(:flashcard)
      create(
        :attempt,
        flashcard: low_confidence_flashcard,
        user: user,
        confidence: 1
      )
      flashcard = create(:flashcard)
      create(:attempt, flashcard: flashcard, user: user, confidence: 1)
      create(:attempt, flashcard: flashcard, user: user, confidence: 5)

      result = FlashcardsNeedingReviewQuery.new(user).run

      expect(result).to eq([low_confidence_flashcard])
    end
  end
end
