require "rails_helper"

RSpec.describe CompleteableWithProgress do
  describe "#name" do
    it "delegates to its completeable" do
      name = "some-name"
      exercise = Exercise.new(name: name)
      completeable_with_progress = CompleteableWithProgress
        .new(exercise, "Unstarted")

      result = completeable_with_progress.name

      expect(result).to eq(name)
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
      completeable_with_progress = CompleteableWithProgress
        .new(exercise, "In Progress")

      result = completeable_with_progress.state

      expect(result).to eq("In Progress")
    end
  end
end
