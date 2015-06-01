class QuestionsController < ApplicationController
  before_action :require_login

  def show
    @quiz = find_quiz
    @question = find_question
    @reviewing = params[:mode] == "reviewing"
  end

  private

  def find_question
    Question.find(params[:id])
  end

  def find_quiz
    Quiz.find(params[:quiz_id])
  end
end
