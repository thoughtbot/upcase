require "rails_helper"

describe ExercisesHelper do
  describe "#state_for" do
    it "is 'Not Started' when the user had not started yet" do
      user = stub("User")
      exercise = stub("Exercise", status_for: nil)

      expect(helper.state_for(user: user, exercise: exercise)).
        to eq("Not Started")
    end

    it "returns the state that the user has for the exercise" do
      user = stub("User")
      status = stub("Status", state: "Started")
      exercise = stub("Exercise", status_for: status)

      expect(helper.state_for(user: user, exercise: exercise)).
        to eq("Started")
    end
  end
end
