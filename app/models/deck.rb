class Deck < ActiveRecord::Base
  validates :title, presence: true

  has_many :flashcards, -> { order(position: :asc) }, dependent: :destroy
  has_many :attempts, -> { order(created_at: :desc) }, through: :flashcards

  def self.published
    where(published: true)
  end

  def self.most_recent_first
    order(created_at: :desc)
  end

  def first_flashcard
    flashcards.first
  end

  def last_attempted_by(user)
    most_recent_attempt_for(user).created_at
  end

  def length
    flashcards_count
  end

  def most_recent_attempt_for(user)
    attempts.where(user: user).first || NullAttempt.new
  end
end
