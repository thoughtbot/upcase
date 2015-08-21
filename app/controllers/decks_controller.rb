class DecksController < ApplicationController
  before_action :require_login

  def index
    @decks = Deck.published.most_recent_first
    @flashcards_to_review = FlashcardsNeedingReviewQuery.new(current_user).run
  end

  def show
    redirect_to deck_flashcard_path(deck, deck.first_flashcard)
  end

  private

  def deck
    Deck.find(params[:id])
  end
end
