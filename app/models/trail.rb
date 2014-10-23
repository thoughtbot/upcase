class Trail < ActiveRecord::Base
  extend FriendlyId

  validates :name, :description, presence: true

  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :steps, -> { order "position ASC" }, dependent: :destroy
  has_many :exercises, through: :steps

  friendly_id :name, use: [:slugged, :finders]

  # Override setters so it preserves the ordering
  def exercise_ids=(new_exercise_ids)
    super
    new_exercise_ids = new_exercise_ids.reject(&:blank?).map(&:to_i)

    new_exercise_ids.each_with_index do |exercise_id, index|
      steps.where(exercise_id: exercise_id).update_all(position: index + 1)
    end
  end

  def steps_remaining_for(user)
    ExerciseWithProgressQuery.
      new(user: user, exercises: exercises).
      count { |exercise| exercise.state != Status::COMPLETE }
  end

  def update_state_for(user)
    TrailWithProgress.new(self, user: user).update_status
  end

  def self.completed_for(user)
    all.
      map { |trail| TrailWithProgress.new(trail, user: user) }.
      select(&:complete?)
  end

  def self.most_recent_published
    order(created_at: :desc).where(published: true)
  end
end
