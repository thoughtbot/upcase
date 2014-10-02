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
      if active?
        Status::ACTIVE
      else
        @state
      end
    end

    private

    def active?
      @previous_state == Status::REVIEWED && @state == Status::NOT_STARTED
    end
  end

  private_constant :ExerciseWithProgress
end
