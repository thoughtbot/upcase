require "rails_helper"

describe "POST /upcase/api/v1/exercises/:exercise_id/status" do
  context "#create" do
    it "updates the status of the given exercise for the authenticated user" do
      exercise = create(:exercise)

      perform_request(exercise.uuid, Status::COMPLETE)

      state = exercise.statuses.where(user: user).most_recent.state
      expect(response).to be_successful
      expect(Status.count).to eq 1
      expect(state).to eq Status::COMPLETE
    end
  end

  def perform_request(uuid, state)
    post(
      api_v1_exercise_status_path(uuid),
      params: {
        access_token: access_token,
        state: state,
      },
    )
  end

  def access_token
    create(:oauth_access_token, :with_application, user: user).token
  end

  def user
    @user ||= create(:user)
  end
end
