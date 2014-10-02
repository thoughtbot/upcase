require "rails_helper"

describe Dashboard do
  describe "#trails" do
    it "decorates the most recent trails" do
      user = stub(:user)
      undecorated = stub(:undecorated)
      trails = [undecorated]
      trail_with_progress = stub(:trail_with_progress)
      Trail.stubs(:most_recent).returns(trails)
      TrailWithProgress.
        stubs(:new).
        with(undecorated, user: user).
        returns(trail_with_progress)
      dashboard = Dashboard.new(user)

      expect(dashboard.trails).to eq([trail_with_progress])
    end
  end
end
