class Trail < ActiveRecord::Base
  extend FriendlyId

  validates :name, :description, presence: true

  has_many :steps, -> { order "position ASC" }, dependent: :destroy
  has_many :exercises, through: :steps

  friendly_id :name, use: [:slugged, :finders]

  def steps_remaining_for(user)
    ExerciseWithProgressQuery.
      new(user: user, exercises: exercises).
      count { |exercise| exercise.state != Status::REVIEWED }
  end

  def self.most_recent_published
    order(created_at: :desc).where(published: true)
  end
end
