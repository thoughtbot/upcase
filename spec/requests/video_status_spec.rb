require "rails_helper"

describe "Video status" do
  before { sign_in }

  describe "when user started the video" do
    it "creates an In Progress status object" do
      video = create(:video)

      post api_v1_video_status_path(video.wistia_id), params: {
        state: "In Progress",
      }

      expect(response).to be_successful

      status = video.statuses.first
      expect(status).not_to be_nil
      expect(status).to be_in_progress
      expect(status.user).to eq @current_user
    end
  end

  describe "when user finish the video" do
    it "updates the status project to Complete" do
      video = create(:video)
      video.statuses.create(user: @current_user, state: Status::IN_PROGRESS)

      post api_v1_video_status_path(video.wistia_id), params: {
        state: "Complete",
      }

      video.reload
      expect(video.statuses.most_recent).to be_complete
    end
  end

  def sign_in
    @current_user = create(:user)
    sign_in_as(@current_user)
  end
end
