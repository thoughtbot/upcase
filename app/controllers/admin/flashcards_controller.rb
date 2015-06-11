class Admin::FlashcardsController < ApplicationController
  def new
    @deck = find_deck
    @flashcard = @deck.flashcards.new
  end

  def create
    @deck = find_deck
    @flashcard = @deck.flashcards.create(flashcard_params)

    if @flashcard.save
      redirect_to admin_deck_path(@deck)
    else
      render :new
    end
  end

  def edit
    @deck = find_deck
    @flashcard = @deck.flashcards.find(params[:id])
  end

  def update
    @deck = find_deck
    @flashcard = @deck.flashcards.find(params[:id])

    @flashcard.update(flashcard_params)

    redirect_to admin_deck_path(@deck)
  end

  private

  def find_deck
    Deck.find(params[:deck_id])
  end

  def flashcard_params
    params.require(:flashcard).permit(:title, :prompt, :answer, :position)
  end
end
