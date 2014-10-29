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
    state != Status::UNSTARTED
  end

  def unstarted?
    [Status::UNSTARTED, Status::NEXT_UP].include? state
  end

  def in_progress?
    state == Status::IN_PROGRESS
  end

  def complete?
    state == Status::COMPLETE
  end

  private

  def next_up?
    @previous_exercise_state == Status::COMPLETE &&
      @state == Status::UNSTARTED
  end
end
