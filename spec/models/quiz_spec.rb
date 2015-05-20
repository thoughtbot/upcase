require "rails_helper"

describe Quiz do
  it { should validate_presence_of(:title) }

  it { should have_many(:questions).dependent(:destroy) }

  describe ".with_questions" do
    it "returns only quizzes with questions" do
      first_quiz, second_quiz = create_pair(:quiz)

      question = create(:question, quiz: first_quiz)

      expect(Quiz.with_questions).to eq([first_quiz])
    end
  end

  describe "#first_question" do
    it "returns the first question" do
      quiz = create(:quiz)
      questions = create_list(:question, 2, quiz: quiz)

      expect(quiz.first_question).to eq(questions.first)
    end
  end

  describe "#questions" do
    it "returns the questions in position order" do
      quiz = create(:quiz)

      older_question = create(:question, quiz: quiz, position: 2)
      newer_question = create(:question, quiz: quiz, position: 1)

      expect(quiz.questions).to match([newer_question, older_question])
    end
  end

  describe "#length" do
    it "returns the number of questions the quiz has" do
      quiz = create(:quiz)
      create(:question, quiz: quiz)
      create(:question, quiz: quiz)

      result = quiz.length

      expect(result).to eq(2)
    end
  end
end
