class TrailWithProgress < SimpleDelegator
  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def unstarted?
    status.state == Status::UNSTARTED
  end

  def complete?
    status.state == Status::COMPLETE
  end

  def status
    statuses_by_id[@trail.id].try(:first) || Unstarted.new
  end

  def update_status
    if exercises.all?(&:complete?)
      statuses.create!(user: @user, state: Status::COMPLETE)
    elsif exercises.any?(&:in_progress?)
      statuses.create!(user: @user, state: Status::IN_PROGRESS)
    end
  end

  def exercises
    ExerciseWithProgressQuery.new(
      user: @user,
      exercises: @trail.exercises
    ).to_a
  end

  private

  def statuses_by_id
    @statuses ||= Status.
      where(completeable: @trail, user: @user).
      order("created_at DESC").
      group_by(&:completeable_id)
  end
end
