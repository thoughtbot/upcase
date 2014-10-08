class Trail < ActiveRecord::Base
  extend FriendlyId

  validates :name, presence: true

  has_many :steps, dependent: :destroy
  has_many :exercises, through: :steps

  friendly_id :name, use: [:slugged, :finders]

  def steps_remaining_for(user)
    exercises.
      to_a.
      count { |exercise| exercise.status_for(user).state != Status::REVIEWED }
  end

  def self.most_recent_published
    order(created_at: :desc).where(published: true)
  end
end
