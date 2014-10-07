class Trail < ActiveRecord::Base
  validates :name, presence: true

  has_many :steps, dependent: :destroy
  has_many :exercises, through: :steps

  def steps_remaining_for(user)
    exercises.
      to_a.
      count { |exercise| exercise.status_for(user).state != Status::REVIEWED }
  end

  def self.most_recent_published
    order(created_at: :desc).where(published: true)
  end
end
