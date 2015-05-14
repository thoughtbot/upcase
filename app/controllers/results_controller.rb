class ResultsController < ApplicationController
  def show
    @quiz = find_quiz
  end

  private

  def find_quiz
    Quiz.find(params[:quiz_id])
  end
end
