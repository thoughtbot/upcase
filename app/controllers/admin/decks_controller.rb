class Admin::DecksController < ApplicationController
  def index
    @decks = Deck.all
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = build_deck
    if @deck.save
      redirect_to admin_deck_path(@deck)
    else
      render :new
    end
  end

  def show
    @deck = find_deck
  end

  private

  def find_deck
    Deck.find(params[:id])
  end

  def build_deck
    Deck.new(deck_params)
  end

  def deck_params
    params.require(:deck).permit(:title)
  end
end
