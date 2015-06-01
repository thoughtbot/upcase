class QuizzesController < ApplicationController
  before_action :require_login

  def index
    @quizzes = Quiz.published
    @questions_to_review = QuestionsNeedingReviewQuery.new(current_user).run
  end

  def show
    redirect_to quiz_question_path(quiz, quiz.first_question)
  end

  private

  def quiz
    Quiz.find(params[:id])
  end
end
