class LatestAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :flashcard

  def self.by(user)
    where(user_id: user.id)
  end

  def self.confidence_below(level)
    where("confidence < ?", level)
  end

  private

  def read_only
    true
  end
end
