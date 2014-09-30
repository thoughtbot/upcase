require "rails_helper"

describe Api::V1::StatusesController do
  context "#update" do
    it "updates the status of the given exercise for the authenticated user" do
      exercise = create(:exercise)
      user = create(:user)
      controller.stubs(:resource_owner).returns(user)

      post :create, exercise_uuid: exercise.uuid, state: "Submitted"

      expect(response).to be_success
      expect(exercise.status_for(user).state).to eq "Submitted"
    end
  end
end
