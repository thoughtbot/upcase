module QuizHelper
  def review_link(flashcard)
    link_to(
      flashcard.title,
      quiz_flashcard_path(flashcard.quiz, flashcard, mode: "reviewing")
    )
  end
end
