require "rails_helper"

describe CompleteableWithProgress do
  describe "#title" do
    it "delegates to its completeable" do
      title = "some-title"
      exercise = Exercise.new(title: title)
      completeable_with_progress = CompleteableWithProgress.
        new(exercise, "Unstarted")

      result = completeable_with_progress.title

      expect(result).to eq(title)
    end
  end

  describe "#state" do
    it "is 'Next Up' if previous is reviewed and current not started" do
      exercise = Exercise.new
      completeable_with_progress = CompleteableWithProgress.new(
        exercise,
        "Unstarted",
        "Complete"
      )

      result = completeable_with_progress.state

      expect(result).to eq(Status::NEXT_UP)
    end

    it "is what was passed in initializer otherwise" do
      exercise = Exercise.new
      completeable_with_progress = CompleteableWithProgress.
        new(exercise, "In Progress")

      result = completeable_with_progress.state

      expect(result).to eq("In Progress")
    end
  end

  describe "#can_be_accessed?" do
    [Status::IN_PROGRESS, Status::COMPLETE, Status::NEXT_UP].each do |state|
      it "can be accessed if is #{state}" do
        exercise = Exercise.new
        completeable_with_progress = CompleteableWithProgress.
          new(exercise, state)

        result = completeable_with_progress.can_be_accessed?

        expect(result).to be_truthy
      end
    end

    it "can't be accessed if is Unstarted" do
      exercise = Exercise.new
      completeable_with_progress = CompleteableWithProgress.
        new(exercise, "Unstarted")

      result = completeable_with_progress.can_be_accessed?

      expect(result).to be_falsy
    end
  end
end
