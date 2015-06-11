class FlashcardsController < ApplicationController
  before_action :require_login

  def show
    @quiz = find_quiz
    @flashcard = find_flashcard
    @reviewing = params[:mode] == "reviewing"
  end

  private

  def find_flashcard
    Flashcard.find(params[:id])
  end

  def find_quiz
    Quiz.find(params[:quiz_id])
  end
end
