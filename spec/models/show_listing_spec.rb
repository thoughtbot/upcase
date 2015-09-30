require "rails_helper"

describe ShowListing do
  describe "#videos_with_status" do
    it "decorates videos with the current users view status" do
      show = create(:show)
      video = create(:video, :published, watchable: show)
      old_status = create(:status, completeable: video)
      new_status = create(:status, completeable: video, user: old_status.user)

      videos = ShowListing.new(show, old_status.user).videos_with_status

      expect(videos.size).to eq 1
      expect(videos.first.id).to eq video.id
      expect(videos.first.status).to eq new_status
    end
  end
end
