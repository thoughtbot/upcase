class LatestAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard

  default_scope { order(:id) }

  def self.by(user)
    where(user_id: user.id)
  end

  def self.confidence_below(level)
    where("confidence < ?", level)
  end

  private

  # :nocov:
  def read_only
    true
  end
  # :nocov:
end
