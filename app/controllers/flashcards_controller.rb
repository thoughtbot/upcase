class FlashcardsController < ApplicationController
  def show
    @deck = find_deck
    @flashcard = find_flashcard
    @reviewing = params[:mode] == "reviewing"
  end

  private

  def find_flashcard
    Flashcard.find(params[:id])
  end

  def find_deck
    Deck.find(params[:deck_id])
  end
end
