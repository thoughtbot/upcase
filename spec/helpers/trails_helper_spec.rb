require "rails_helper"

describe TrailsHelper do
  include Rails.application.routes.url_helpers

  describe "#trail_breadcrumbs" do
    it "constructs breadcrumbs for a trail" do
      topic = build_stubbed(:topic, slug: "design")
      trail = build_stubbed(:trail, slug: "sass", topics: [topic])

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

  describe "#trail_call_to_action" do
    context "for a subscriber" do
      context "for a trail with a trial video" do
        it "renders a Start Trail link" do
          trail = create(:trail, :with_sample_video)
          user = build(:subscriber)
          allow(helper).to receive(:current_user).and_return(user)

          html = helper.trail_call_to_action(trail)

          expect(html).to include(I18n.t("trails.start_trail"))
          expect(html).to include(video_path(trail.videos.first))
        end
      end
    end

    context "for a sampler" do
      context "for a trail with no trial video" do
        it "renders a Visit Trail link" do
          trail = create(:trail, :video)
          user = create(:user)
          allow(helper).to receive(:current_user).and_return(user)

          html = helper.trail_call_to_action(trail)

          expect(html).to include(I18n.t("trails.visit_trail"))
          expect(html).to include(trail_path(trail))
        end
      end

      context "for a trail with a trial video" do
        it "renders a Start Trail link" do
          trail = create(:trail, :with_sample_video)
          user = create(:user)
          allow(helper).to receive(:current_user).and_return(user)

          html = helper.trail_call_to_action(trail)

          expect(html).to include(I18n.t("trails.start_trail"))
          expect(html).to include(video_path(trail.videos.first))
        end
      end
    end

    context "for a guest" do
      context "for a trail with no trial video" do
        it "renders a Visit Trail link" do
          trail = create(:trail, :video)
          allow(helper).to receive(:current_user).and_return(Guest.new)

          html = helper.trail_call_to_action(trail)

          expect(html).to include(I18n.t("trails.visit_trail"))
          expect(html).to include(trail_path(trail))
        end
      end

      context "for a trail with a trial video" do
        it "renders an auth to access link" do
          trail = create(:trail, :with_sample_video)
          allow(helper).to receive(:current_user).and_return(Guest.new)

          html = helper.trail_call_to_action(trail)

          expect(html).to include(I18n.t("trails.start_for_free"))
          expect(html).to include(video_auth_to_access_path(trail.videos.first))
        end
      end
    end
  end
end
