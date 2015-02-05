require "rails_helper"

describe Explore do
  describe "#show" do
    it "returns The Weekly Iteration" do
      user = double
      twi_show = double
      allow(Show).to receive(:the_weekly_iteration).and_return(twi_show)

      show = Explore.new(user).show

      expect(show).to eq(twi_show)
    end
  end

  describe "#latest_video_tutorial" do
    it "returns most recent VideoTutorial" do
      user = double
      video_tutorial = double
      scope = double("Scope", last: video_tutorial)
      allow(VideoTutorial).to receive(:order).with(:created_at).
        and_return(scope)

      video = Explore.new(user).latest_video_tutorial

      expect(video).to eq(video)
    end
  end

  describe "#trails" do
    it "returns most recently published Trails" do
      user = double
      explore = Explore.new(user)

      expect(explore.trails).to find_relation(Trail.most_recent_published)
    end
  end
end
