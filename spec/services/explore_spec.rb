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
    it "returns most recent active VideoTutorial" do
      user = double
      video_tutorial = double
      order_scope = double("Order Scope", last: video_tutorial)
      active_scope = double("Active Scope", order: order_scope)
      allow(VideoTutorial).to receive(:active).and_return(active_scope)
      allow(active_scope).to receive(:order).with(:created_at).
        and_return(order_scope)

      result = Explore.new(user).latest_video_tutorial

      expect(result).to eq(video_tutorial)
      expect(VideoTutorial).to have_received(:active)
      expect(active_scope).to have_received(:order).with(:created_at)
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
