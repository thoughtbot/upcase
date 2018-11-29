class Deck < ApplicationRecord
  validates :title, presence: true

  has_many :flashcards,
    -> { order(position: :asc) },
    dependent: :destroy,
    inverse_of: :deck

  def self.published
    where(published: true)
  end

  def self.most_recent_first
    order(created_at: :desc)
  end

  def first_flashcard
    flashcards.first
  end

  def length
    flashcards_count
  end
end
