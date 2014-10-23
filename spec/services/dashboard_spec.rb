require "rails_helper"

describe Dashboard do
  describe "#trails" do
    it "decorates the most recent, published trails" do
      dashboard = Dashboard.new(user)
      trail_show = stub("undecorated_show")
      trail_hide = stub("undecorated_hide")
      Trail.stubs(:most_recent_published).returns([trail_show, trail_hide])
      _hidden = setup_trail_with_progress(trail_hide, active: false)
      trail_with_progress_show = setup_trail_with_progress(
        trail_show,
        active: true
      )

      expect(dashboard.trails).to eq([trail_with_progress_show])
    end
  end

  describe "#has_completed_trails?" do
    it "returns false if it has no completed trails" do
      user = build_stubbed(:user)
      dashboard = Dashboard.new(user)

      expect(dashboard).not_to have_completed_trails
    end

    it "returns true if it has completed trails" do
      user = create(:user)
      trail = create(:trail)
      create(:status, completeable: trail, state: "Complete", user: user)
      dashboard = Dashboard.new(user)

      expect(dashboard).to have_completed_trails
    end
  end

  def setup_trail_with_progress(trail, active:)
    trail_with_progress = stub(
      "trail_with_progress_#{active}",
      active?: active
    )

    TrailWithProgress.
      stubs(:new).
      with(trail, user: user).
      returns(trail_with_progress)

    trail_with_progress
  end

  def user
    @user ||= stub(:user)
  end
end
