class ExerciseTracker
  def initialize(exercise)
    @exercise = exercise
  end

  def started_events
    [
      [
        "Started exercise",
        {
          name: exercise.name,
          watchable_name: exercise.trail_name,
        },
      ], [
        "Touched Step",
        {
          name: exercise.name,
          watchable_name: exercise.trail_name,
          type: "Exercise",
        },
      ]
    ]
  end

  def finished_events
    [
      [
        "Finished exercise",
        {
          name: exercise.name,
          watchable_name: exercise.trail_name,
        },
      ],
    ]
  end

  private

  attr_reader :exercise
end
