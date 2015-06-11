class Admin::FlashcardPreviewsController < ApplicationController
  def create
    @quiz = find_quiz
    @flashcard = @quiz.flashcards.new(flashcard_params)
    @reviewing = true

    render "flashcards/show", layout: false
  end

  private

  def find_quiz
    Quiz.find(params[:quiz_id])
  end

  def flashcard_params
    params.require(:flashcard).permit(:title, :prompt, :answer, :position)
  end
end
