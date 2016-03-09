class DecksController < ApplicationController
  before_action :require_login

  def index
    @deck_list = DeckList.new(current_user)
  end

  def show
    redirect_to deck_flashcard_path(deck, deck.first_flashcard)
  end

  private

  def deck
    Deck.find(params[:id])
  end
end
