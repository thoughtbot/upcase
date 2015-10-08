require "rails_helper"

describe TrailsHelper do
  describe "#trail_breadcrumbs" do
    it "constructs breadcrumbs for a trail" do
      topic = build_stubbed(:topic, slug: "design")
      trail = build_stubbed(:trail, slug: "sass", topic: topic)

      result = helper.trail_breadcrumbs(trail)

      expect(result).to include practice_path
      expect(result).to include "/design"
      expect(result).to include "/sass"
    end
  end
end
