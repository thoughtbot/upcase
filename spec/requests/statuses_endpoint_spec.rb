require "rails_helper"

describe "POST /api/v1/exercises/:exercise_uuid/status" do
  context "#create" do
    it "updates the status of the given exercise for the authenticated user" do
      exercise = create(:exercise)

      perform_request(exercise.uuid, Status::COMPLETE)

      state = exercise.statuses.where(user: user).most_recent.state
      expect(response).to be_success
      expect(Status.count).to eq 1
      expect(state).to eq Status::COMPLETE
    end
  end

  def perform_request(uuid, state)
    post(
      "/api/v1/exercises/#{uuid}/status",
      access_token: access_token,
      state: state,
    )
  end

  def access_token
    create(:oauth_access_token, :with_application, user: user).token
  end

  def user
    @user ||= create(:user)
  end
end
