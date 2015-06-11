module DeckHelper
  def review_link(flashcard)
    link_to(
      flashcard.title,
      deck_flashcard_path(flashcard.deck, flashcard, mode: "reviewing")
    )
  end
end
