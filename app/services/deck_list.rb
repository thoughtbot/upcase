class DeckList
  def initialize(user)
    @user = user
  end

  def decks
    @_decks ||= Deck.published.most_recent_first
  end

  def flashcards_to_review
    @_flashcards_to_review ||= FlashcardsNeedingReviewQuery.
      new(user).
      run
  end

  def last_attempted_at(deck)
    latest_deck_attempt = latest_deck_attempts.detect do |attempt|
      attempt.deck_id == deck.id
    end || NullAttempt.new

    latest_deck_attempt.updated_at
  end

  private

  attr_reader :user

  def latest_deck_attempts
    @_latest_deck_attempts ||= LatestDeckAttempt.by(user)
  end
end
