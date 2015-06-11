class Deck < ActiveRecord::Base
  validates :title, presence: true

  has_many :flashcards, -> { order(position: :asc) }, dependent: :destroy

  def self.published
    where(published: true)
  end

  def first_flashcard
    flashcards.first
  end

  def length
    flashcards.count
  end
end
