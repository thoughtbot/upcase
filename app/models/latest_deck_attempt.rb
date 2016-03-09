class LatestDeckAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  def self.by(user)
    where(user_id: user.id)
  end
end
