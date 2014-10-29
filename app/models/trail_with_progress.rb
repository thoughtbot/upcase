class TrailWithProgress < SimpleDelegator
  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def unstarted?
    exercises.all? { |exercise| exercise.state == Status::UNSTARTED }
  end

  def complete?
    exercises.all? { |exercise| exercise.state == Status::COMPLETE }
  end

  def exercises
    ExerciseWithProgressQuery.new(
      user: @user,
      exercises: @trail.exercises
    ).to_a
  end
end
