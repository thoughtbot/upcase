require "rails_helper"

describe TrailsHelper do
  include Rails.application.routes.url_helpers

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

  describe "#completeable_link" do
    context "with an exercise completeable" do
      it "uses the exercise URL as the link target" do
        exercise = build_stubbed(:exercise)

        result = helper.completeable_link(exercise) {}

        expect(result).to have_link(exercise.name, href: exercise.url)
      end
    end

    context "with an video completeable" do
      it "uses the video path as the link target" do
        video = build_stubbed(:video)

        result = helper.completeable_link(video) {}

        expect(result).to have_link(video.name, href: video_path(video))
      end
    end
  end
end
