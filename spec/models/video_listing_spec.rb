require "rails_helper"

RSpec.describe VideoListing do
  describe "#videos_with_status" do
    it "decorates videos with the current users view status" do
      video = create(:video, :published)
      old_status = create(:status, completeable: video)
      new_status = create(:status, completeable: video, user: old_status.user)

      videos = VideoListing.new(fake_relation(video), old_status.user).to_a

      expect(videos.size).to eq 1
      expect(videos.first.id).to eq video.id
      expect(videos.first.status).to eq new_status
      expect(videos.first.status_class).to eq "in-progress"
    end
  end

  def fake_relation(video)
    [video].tap do |relation|
      allow(relation).to receive(:includes).and_return(relation)
    end
  end
end
