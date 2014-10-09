# Factory which can decorate an Exercise with the statuses for a given user
class ExerciseWithProgressQuery
  include Enumerable

  def initialize(user:, exercises:)
    @user = user
    @exercises = exercises
  end

  def each(&block)
    previous_exercise_state = nil
    @exercises.all.map do |exercise|
      state = status_for(exercise.id).state
      ExerciseWithProgress.new(exercise, state, previous_exercise_state).tap do
        previous_exercise_state = state
      end
    end.each(&block)
  end

  def includes(*args)
    self.class.new(user: @user, exercises: @exercises.includes(*args))
  end

  def status_for(exercise_id)
    statuses[exercise_id].try(:first) || NotStarted.new
  end

  private

  def statuses
    @statuses ||= Status.
      where(exercise_id: @exercises.ids, user: @user).
      order("created_at DESC").
      group_by(&:exercise_id)
  end
end
