require "rails_helper"

describe Quiz do
  it { should validate_presence_of(:title) }

  it { should have_many(:flashcards).dependent(:destroy) }

  describe ".published" do
    it "returns only quizzes explicitly marked as published" do
      published_quiz = create(:quiz, published: true)
      _unpublished_quiz = create(:quiz, published: false)

      expect(Quiz.published).to eq([published_quiz])
    end
  end

  describe "#first_flashcard" do
    it "returns the first flashcard" do
      quiz = create(:quiz)
      flashcards = create_list(:flashcard, 2, quiz: quiz)

      expect(quiz.first_flashcard).to eq(flashcards.first)
    end
  end

  describe "#flashcards" do
    it "returns the flashcards in position order" do
      quiz = create(:quiz)

      older_flashcard = create(:flashcard, quiz: quiz, position: 2)
      newer_flashcard = create(:flashcard, quiz: quiz, position: 1)

      expect(quiz.flashcards).to match([newer_flashcard, older_flashcard])
    end
  end

  describe "#length" do
    it "returns the number of flashcards the quiz has" do
      quiz = create(:quiz)
      create(:flashcard, quiz: quiz)
      create(:flashcard, quiz: quiz)

      result = quiz.length

      expect(result).to eq(2)
    end
  end
end
