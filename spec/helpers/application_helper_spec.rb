require "rails_helper"

describe ApplicationHelper do
  describe "#exercise_path" do
    it "returns the remote URL for the exercise" do
      exercise = build_stubbed(:exercise)

      result = helper.exercise_path(exercise)

      expect(result).to eq(exercise.url)
    end
  end
end
