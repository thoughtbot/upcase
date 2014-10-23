class TrailWithProgress < SimpleDelegator
  delegate :unstarted?, :in_progress?, :complete?, to: :status

  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def just_finished?
    complete? && status.created_at >= 5.days.ago
  end

  def active?
    unstarted? || in_progress? || just_finished?
  end

  def update_status
    if exercises.all?(&:complete?)
      statuses.create!(user: @user, state: Status::COMPLETE)
    elsif exercises.any?(&:in_progress?) || exercises.any?(&:complete?)
      statuses.create!(user: @user, state: Status::IN_PROGRESS)
    end
  end

  def exercises
    ExerciseWithProgressQuery.new(
      user: @user,
      exercises: @trail.exercises
    ).to_a
  end

  def status
    statuses_by_id[@trail.id].try(:first) || Unstarted.new
  end

  private

  attr_reader :trail, :user

  def statuses_by_id
    @statuses ||= Status.
      where(completeable: @trail, user: @user).
      order("created_at DESC").
      group_by(&:completeable_id)
  end
end
