require "rails_helper"

describe Api::V1::StatusesController do
  describe "#create" do
    it "returns a 401 when users are not authenticated" do
      post :create, exercise_uuid: "exercise-uuid"

      expect(response.code).to eq "401"
    end

    it "returns a 404 when exercise doesn't exist" do
      stub_authenticated_user

      expect do
        post :create, exercise_uuid: "exercise-uuid"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "updates the status of the given exercise for the authenticated user" do
      stub_authenticated_user
      exercise = stub_exercise

      post :create, exercise_uuid: exercise.uuid, state: Status::COMPLETE

      expect(response.code).to eq "200"
      expect(exercise).to have_received(:update_trails_state_for)
    end
  end

  def stub_exercise
    exercise = build_stubbed(:exercise)
    exercise.stubs(:update_trails_state_for)
    Exercise.stubs(:find_by!).returns(exercise)
    exercise
  end

  def stub_authenticated_user
    user = build_stubbed(:user)
    User.stubs(:find).returns(user)
    access_token = build_stubbed(:oauth_access_token, user: user)
    Doorkeeper::OAuth::Token.stubs(:authenticate).returns(access_token)
    user
  end
end
