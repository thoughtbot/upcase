class DecksController < ApplicationController
  def index
    @decks = Deck.published.most_recent_first
    @flashcards_to_review = flashcards_to_review
  end

  def show
    redirect_to deck_flashcard_path(deck, deck.first_flashcard)
  end

  private

  def deck
    Deck.find(params[:id])
  end

  def flashcards_to_review
    if signed_in?
      FlashcardsNeedingReviewQuery.new(current_user).run
    else
      Flashcard.none
    end
  end
end
