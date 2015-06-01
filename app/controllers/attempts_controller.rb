class AttemptsController < ApplicationController
  before_action :require_login

  def create
    question.attempts.create!(attempt_params)

    redirect_to_next_question_or_results(question)
  end

  private

  def redirect_to_next_question_or_results(question)
    if question.next
      redirect_to quiz_question_path(question.quiz, question.next)
    else
      redirect_to quiz_results_path(question.quiz)
    end
  end

  def attempt_params
    params.require(:attempt).permit(:confidence).merge(user: current_user)
  end

  def question
    @_question ||= Question.find(params[:question_id])
  end
end
