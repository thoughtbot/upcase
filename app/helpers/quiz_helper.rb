module QuizHelper
  def review_link(question)
    link_to(
      question.title,
      quiz_question_path(question.quiz, question, mode: "reviewing")
    )
  end
end
