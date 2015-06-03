class Attempt < ActiveRecord::Base
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :confidence, presence: true

  belongs_to :question
  belongs_to :user

  LOW_CONFIDENCE = 1
  HIGH_CONFIDENCE = 5

  def low_confidence?
    confidence == LOW_CONFIDENCE
  end
end
