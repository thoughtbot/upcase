class TrailWithProgress < SimpleDelegator
  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def exercises
    previous_state = Status::REVIEWED
    @trail.exercises.map do |exercise|
      state = exercise.status_for(@user).state
      ExerciseWithProgress.new(exercise, state, previous_state).tap do
        previous_state = state
      end
    end
  end

  class ExerciseWithProgress < SimpleDelegator
    def initialize(exercise, state, previous_state)
      super(exercise)
      @exercise = exercise
      @state = state
      @previous_state = previous_state
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
      @previous_state == Status::REVIEWED && @state == Status::NOT_STARTED
    end
  end

  private_constant :ExerciseWithProgress
end
