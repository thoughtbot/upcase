module ExercisesHelper
  def state_for(user:, exercise:)
    if status = exercise.status_for(user)
      status.state
    else
      "Not Started"
    end
  end
end
