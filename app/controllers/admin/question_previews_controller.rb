class Admin::QuestionPreviewsController < ApplicationController
  def create
    @quiz = find_quiz
    @question = @quiz.questions.new(question_params)
    @reviewing = true

    render "questions/show", layout: false
  end

  private

  def find_quiz
    Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:title, :prompt, :answer, :position)
  end
end
