class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all
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
