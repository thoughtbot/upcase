require "rails_helper"

describe "Video status" do
  before { sign_in }

  describe "when user started the video" do
    it "creates an In Progress status object" do
      video = create(:video)

      post "/api/v1/videos/#{video.wistia_id}/status", state: "In Progress"

      expect(response).to be_success

      status = video.statuses.first
      expect(status).not_to be_nil
      expect(status).to be_in_progress
      expect(status.user).to eq @current_user
    end

    it "sends data to analytics backend" do
      video = create(:video)

      post "/api/v1/videos/#{video.wistia_id}/status", state: "In Progress"

      expect(analytics).to have_tracked("Started video").
        for_user(@current_user).
        with_properties(video_slug: video.slug)
    end
  end

  describe "when user finish the video" do
    it "updates the status project to Complete" do
      video = create(:video)
      video.statuses.create(user: @current_user, state: Status::IN_PROGRESS)

      post "/api/v1/videos/#{video.wistia_id}/status", state: "Complete"

      video.reload
      expect(video.statuses.last).to be_complete
    end

    it "sends data to analytics backend" do
      video = create(:video)
      video.statuses.create(user: @current_user, state: Status::IN_PROGRESS)

      post "/api/v1/videos/#{video.wistia_id}/status", state: "Complete"

      expect(analytics).to have_tracked("Finished video").
        for_user(@current_user).
        with_properties(video_slug: video.slug)
    end
  end

  def sign_in
    @current_user = create(:user)
    post(
      "/session",
      session: {
        email: @current_user.email,
        password: "password"
      }
    )
  end
end
