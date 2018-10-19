require "rails_helper"

describe TrailsHelper do
  include Rails.application.routes.url_helpers

  describe "#trail_breadcrumbs" do
    it "constructs breadcrumbs for a trail" do
      topic = build_stubbed(:topic, slug: "design")
      other_topic = build_stubbed(:topic, slug: "development")
      trail = build_stubbed(:trail, slug: "sass", topics: [topic, other_topic])

      result = helper.trail_breadcrumbs(trail)

      expect(ordered_links_in(result)).to eq [
        practice_path,
        topic_path(topic),
        topic_path(other_topic),
        trail_path(trail),
      ]
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

  describe "#trail_call_to_action" do
    context "for a signed in user" do
      it "renders a Start Trail link" do
        trail = create(:trail, :with_sample_video)
        user = build(:user)
        allow(helper).to receive(:current_user).and_return(user)

        html = helper.trail_call_to_action(trail)

        expect(html).to include(I18n.t("trails.start_trail"))
        expect(html).to include(video_path(trail.videos.first))
      end
    end

    context "for a guest user" do
      it "renders a Visit Trail link" do
        trail = create(:trail, :video)
        allow(helper).to receive(:signed_in?).and_return(false)

        html = helper.trail_call_to_action(trail)

        expect(html).to include(I18n.t("trails.visit_trail"))
        expect(html).to include(trail_path(trail))
      end
    end
  end

  describe "#completion_time" do
    context "when the time is less than an hour" do
      it "returns the time in minutes" do
        time = helper.completion_time(55)

        expect(time).to eq("55 minutes")
      end
    end

    context "when the time is more than an hour" do
      it "returns time in hours and minutes" do
        time = helper.completion_time(110)

        expect(time).to eq("1 hour 50 minutes")
      end
    end
  end

  def ordered_links_in(html)
    Nokogiri::HTML(html).css("a").map { |x| x[:href] }
  end
end
