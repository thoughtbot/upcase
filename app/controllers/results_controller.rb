class ResultsController < ApplicationController
  def show
    @deck = find_deck
  end

  private

  def find_deck
    Deck.find(params[:deck_id])
  end
end
