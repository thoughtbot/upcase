require "rails_helper"

describe Explore do
  describe "#show" do
    it "returns The Weekly Iteration" do
      user = stub
      twi_show = stub
      Show.stubs(:the_weekly_iteration).returns(twi_show)

      show = Explore.new(user).show

      expect(show).to eq(twi_show)
    end
  end

  describe "#latest_video_tutorial" do
    it "returns most recent VideoTutorial" do
      user = stub
      video_tutorial = stub
      scope = stub(last: video_tutorial)
      VideoTutorial.stubs(:order).with(:created_at).returns(scope)

      video = Explore.new(user).latest_video_tutorial

      expect(video).to eq(video)
    end
  end

  describe "#trails" do
    it "returns most recently published Trails" do
      user = stub
      explore = Explore.new(user)

      expect(explore.trails).to find_relation(Trail.most_recent_published)
    end
  end
end
