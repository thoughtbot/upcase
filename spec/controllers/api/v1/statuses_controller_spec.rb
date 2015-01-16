require "rails_helper"

describe Api::V1::StatusesController do
  describe "#create" do
    it "returns a 401 when users are not authenticated" do
      post :create, exercise_uuid: "exercise-uuid"

      expect(response.code).to eq "401"
    end

    it "returns a 404 when exercise doesn't exist" do
      stub_oauth_authenticated_user

      expect do
        post :create, exercise_uuid: "exercise-uuid"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "updates the status of the given exercise for the authenticated user" do
      stub_oauth_authenticated_user
      exercise = stub_exercise
      updater = mock("status_updater")
      updater.stubs(:update_state)
      StatusUpdater.stubs(:new).returns(updater)

      post :create, exercise_uuid: exercise.uuid, state: Status::COMPLETE

      expect(response.code).to eq "200"
      expect(StatusUpdater).to have_received(:new)
      expect(updater).to have_received(:update_state).with(Status::COMPLETE)
    end
  end

  def stub_exercise
    exercise = build_stubbed(:exercise)
    Exercise.stubs(:find_by!).returns(exercise)
    exercise
  end
end
