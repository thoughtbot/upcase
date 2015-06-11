class Admin::FlashcardPreviewsController < ApplicationController
  def create
    @deck = find_deck
    @flashcard = @deck.flashcards.new(flashcard_params)
    @reviewing = true

    render "flashcards/show", layout: false
  end

  private

  def find_deck
    Deck.find(params[:deck_id])
  end

  def flashcard_params
    params.require(:flashcard).permit(:title, :prompt, :answer, :position)
  end
end
