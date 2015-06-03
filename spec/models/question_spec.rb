require "rails_helper"

describe Question do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:prompt) }
  it { should validate_presence_of(:answer) }

  it { should belong_to(:quiz) }
  it { should have_many(:attempts) }

  describe "#attempts" do
    it "orders by created_at, most recent first" do
      question = create(:question)
      older_attempt = create(:attempt, question: question)
      newer_attempt = create(:attempt, question: question)

      expect(question.attempts).to eq([newer_attempt, older_attempt])
    end
  end

  describe "#next" do
    context "when there are more questions" do
      it "returns the next question" do
        quiz = create(:quiz)
        first_question, second_question = create_list(:question, 2, quiz: quiz)

        expect(first_question.next).to eq(second_question)
      end
    end

    context "when there are no more questions" do
      it "returns nil" do
        question = create(:question)

        expect(question.next).to be_nil
      end
    end
  end

  describe "#quiz_title" do
    it "returns the quiz title" do
      quiz = build_stubbed(:quiz)
      question = build_stubbed(:question, quiz: quiz)

      expect(question.quiz_title).to eq(quiz.title)
    end
  end

  describe "#most_recent_attempt_for" do
    context "the user has attempted the question" do
      it "returns the most recent attempt" do
        user = create(:user)
        question = create(:question)
        attempts = create_list(:attempt, 2, question: question, user: user)

        expect(question.most_recent_attempt_for(user)).to eq(attempts.last)
      end
    end

    context "the user has yet to attempt the question" do
      it "should return a null attempt" do
        user = build_stubbed(:user)
        question = create(:question)

        expect(question.most_recent_attempt_for(user)).to be_a(NullAttempt)
      end
    end
  end

  describe "#saved_for_review?" do
    context "when the user saved it for review" do
      it "returns true" do
        question = create(:question)
        attempt = create(
          :attempt,
          question: question,
          confidence: Attempt::LOW_CONFIDENCE
        )
        user = attempt.user

        expect(question.saved_for_review?(user)).to be_truthy
      end
    end

    context "when the user did not save it for review" do
      it "returns false" do
        question = create(:question)
        attempt = create(
          :attempt,
          question: question,
          confidence: Attempt::HIGH_CONFIDENCE
        )
        user = attempt.user

        expect(question.saved_for_review?(user)).to be_falsey
      end
    end
  end
end
