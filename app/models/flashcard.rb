class Flashcard < ActiveRecord::Base
  validates :title, presence: true
  validates :prompt, presence: true
  validates :answer, presence: true

  belongs_to :deck
  has_many :attempts, -> { order(created_at: :desc) }

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
end
