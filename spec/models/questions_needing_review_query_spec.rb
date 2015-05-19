require "rails_helper"

describe QuestionsNeedingReviewQuery do
  describe "#run" do
    it "returns questions whose last attempt had low confidence" do
      user = create(:user)
      low_confidence_question = create(:question)
      create(
        :attempt,
        question: low_confidence_question,
        user: user,
        confidence: 1
      )
      question = create(:question)
      create(:attempt, question: question, user: user, confidence: 1)
      create(:attempt, question: question, user: user, confidence: 5)

      result = QuestionsNeedingReviewQuery.new(user).run

      expect(result).to eq([low_confidence_question])
    end
  end
end
