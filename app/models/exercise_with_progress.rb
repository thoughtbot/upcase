class ExerciseWithProgress < SimpleDelegator
  def initialize(exercise, state, previous_exercise_state = nil)
    super(exercise)
    @exercise = exercise
    @state = state
    @previous_exercise_state = previous_exercise_state
  end

  def state
    if next_up?
      Status::NEXT_UP
    else
      @state
    end
  end

  def can_be_accessed?
    state != Status::NOT_STARTED
  end

  private

  def next_up?
    @previous_exercise_state == Status::REVIEWED &&
      @state == Status::NOT_STARTED
  end
end
