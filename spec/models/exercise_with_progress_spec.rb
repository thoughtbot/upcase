require "rails_helper"

describe ExerciseWithProgress do
  describe "#title" do
    it "delegates to its exercise" do
      title = stub("title")
      exercise = Exercise.new(title: title)
      exercise_with_progress = ExerciseWithProgress.new(exercise, "Unstarted")

      result = exercise_with_progress.title

      expect(result).to eq(title)
    end
  end

  describe "#state" do
    it "returns state that was passed in initializer" do
      exercise = Exercise.new
      exercise_with_progress = ExerciseWithProgress.new(exercise, "In Progress")

      result = exercise_with_progress.state

      expect(result).to eq("In Progress")
    end
  end

  describe "#can_be_accessed?" do
    [Status::IN_PROGRESS, Status::COMPLETE].each do |state|
      it "can be accessed if is #{state}" do
        exercise = Exercise.new
        exercise_with_progress = ExerciseWithProgress.new(exercise, state)

        result = exercise_with_progress.can_be_accessed?

        expect(result).to be_truthy
      end
    end

    it "can't be accessed if is Unstarted" do
      exercise = Exercise.new
      exercise_with_progress = ExerciseWithProgress.new(exercise, "Unstarted")

      result = exercise_with_progress.can_be_accessed?

      expect(result).to be_falsy
    end
  end
end
