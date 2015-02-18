require "rails_helper"

describe Explore do
  describe "#show" do
    context "when The Weekly Iteration exits" do
      it "returns it" do
        user = double
        the_weekly_iteration = double
        allow(Show).to(
          receive(:the_weekly_iteration).and_return(the_weekly_iteration)
        )

        show = Explore.new(user).show

        expect(show).to eq(the_weekly_iteration)
      end
    end

    context "when The Weekly Iteration does not exist" do
      it "returns a NullShow" do
        user = double
        allow(Show).to receive(:the_weekly_iteration).and_return(nil)

        show = Explore.new(user).show

        expect(show).to be_a NullShow
      end
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
