class ExerciseWithProgress < SimpleDelegator
  attr_reader :state

  def initialize(exercise, state, previous_exercise_state = nil)
    super(exercise)
    @exercise = exercise
    @state = state
    @previous_exercise_state = previous_exercise_state
  end

  def can_be_accessed?
    @state != Status::UNSTARTED || @previous_exercise_state == Status::COMPLETE
  end
end
