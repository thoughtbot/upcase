class Attempt < ApplicationRecord
  validates :user_id, presence: true
  validates :flashcard_id, presence: true
  validates :confidence, presence: true

  belongs_to :flashcard
  belongs_to :user

  LOW_CONFIDENCE = 1
  HIGH_CONFIDENCE = 5

  def low_confidence?
    confidence == LOW_CONFIDENCE
  end
end
