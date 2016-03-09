module DeckHelper
  def review_link(flashcard)
    link_to(
      flashcard.title,
      deck_flashcard_path(flashcard.deck, flashcard, mode: "reviewing")
    )
  end

  def last_attempted_in_words(time)
    if time.present?
      t(".last_attempted", distance: time_ago_in_words(time))
    else
      t(".never_attempted")
    end
  end
end
