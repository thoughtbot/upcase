class QuizzesController < ApplicationController
  before_action :require_login

  def index
    @quizzes = Quiz.published
    @flashcards_to_review = FlashcardsNeedingReviewQuery.new(current_user).run
  end

  def show
    redirect_to quiz_flashcard_path(quiz, quiz.first_flashcard)
  end

  private

  def quiz
    Quiz.find(params[:id])
  end
end
