class AttemptsController < ApplicationController
  before_action :require_login

  def create
    attempt = question.attempts.create!(attempt_params)

    if attempt.low_confidence?
      flash[:notice] = I18n.t("attempts.question_saved")
    end

    redirect_to_next_question_or_results(question)
  end

  def update
    attempt = current_user.attempts.find(params[:id])
    attempt.update_attribute(:confidence, params[:confidence])

    redirect_to(
      quizzes_path,
      notice: I18n.t("attempts.question_removed_from_review_queue")
    )
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
