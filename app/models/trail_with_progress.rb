class TrailWithProgress < SimpleDelegator
  def initialize(trail, user:)
    super(trail)
    @trail = trail
    @user = user
  end

  def exercises
    first_incomplete = true
    @trail.exercises.map do |exercise|
      state = exercise.status_for(@user).state
      ExerciseWithProgress.new(exercise, state, first_incomplete).tap do
        if state != Status::REVIEWED
          first_incomplete = false
        end
      end
    end
  end

  class ExerciseWithProgress < SimpleDelegator
    def initialize(exercise, state, first_incomplete)
      super(exercise)
      @exercise = exercise
      @state = state
      @first_incomplete = first_incomplete
    end

    def active?
      @first_incomplete && @state == Status::NOT_STARTED
    end
  end

  private_constant :ExerciseWithProgress
end
