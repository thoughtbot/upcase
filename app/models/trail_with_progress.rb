class TrailWithProgress < SimpleDelegator
  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def unstarted?
    exercises.all? do |exercise|
      [Status::NOT_STARTED, Status::NEXT_UP].include? exercise.state
    end
  end

  def complete?
    exercises.all? { |exercise| exercise.state == Status::REVIEWED }
  end

  def exercises
    ExerciseWithProgressQuery.new(
      user: @user,
      exercises: @trail.exercises
    ).to_a
  end
end
