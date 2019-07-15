class Flashcard < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title, :prompt, :answer], if: :search_visible?

  validates :title, presence: true
  validates :prompt, presence: true
  validates :answer, presence: true

  belongs_to :deck, counter_cache: true
  has_many :attempts,
    -> { order(created_at: :desc) },
    inverse_of: :flashcard

  acts_as_list scope: :deck

  def next
    lower_item
  end

  def most_recent_attempt_for(user)
    attempts.where(user: user).first || NullAttempt.new
  end

  def deck_title
    deck.title
  end

  def saved_for_review?(user)
    most_recent_attempt_for(user).low_confidence?
  end

  def search_visible?
    deck.published?
  end
end
