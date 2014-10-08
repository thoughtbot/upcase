require "rails_helper"

describe ExerciseWithProgress do
  describe "#title" do
    it "delegates to its exercise" do
      title = stub("title")
      exercise = Exercise.new(title: title)
      exercise_with_progress = ExerciseWithProgress.new(exercise, "Not Started")

      result = exercise_with_progress.title

      expect(result).to eq(title)
    end
  end

  describe "#state" do
    it "is 'Next Up' if previous is reviewed and current not started" do
      exercise = Exercise.new
      exercise_with_progress = ExerciseWithProgress.new(
        exercise,
        "Not Started",
        "Reviewed"
      )

      result = exercise_with_progress.state

      expect(result).to eq(Status::NEXT_UP)
    end

    it "is what was passed in initializer otherwise" do
      exercise = Exercise.new
      exercise_with_progress = ExerciseWithProgress.new(exercise, "Started")

      result = exercise_with_progress.state

      expect(result).to eq("Started")
    end
  end

  describe "#can_be_accessed?" do
    [Status::STARTED, Status::PUSHED, Status::SUBMITTED, Status::REVIEWED,
     Status::NEXT_UP].each do |state|
      it "can be accessed if is #{state}" do
        exercise = Exercise.new
        exercise_with_progress = ExerciseWithProgress.new(exercise, state)

        result = exercise_with_progress.can_be_accessed?

        expect(result).to be_truthy
      end
    end

    it "can't be accessed if is Not Started" do
      exercise = Exercise.new
      exercise_with_progress = ExerciseWithProgress.new(exercise, "Not Started")

      result = exercise_with_progress.can_be_accessed?

      expect(result).to be_falsy
    end
  end
end
