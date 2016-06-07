require "rails_helper"

describe "trails/_header" do
  include SessionHelpers

  context "when signed out" do
    context "when there are trial videos in the trail" do
      it "includes a 'Start for Free' button" do
        stub_signed_in false
        video = build_stubbed(:video)
        trail = build_trail(sample_video: video)

        render_trail(trail)

        expect(rendered).to have_start_for_free_link_to(
          video_auth_to_access_path(video),
        )
      end
    end

    context "when there are no trial videos in the trail" do
      it "does not include a 'Start for Free' button" do
        stub_signed_in false
        trail = build_trail(sample_video: nil)

        render_trail(trail)

        expect(rendered).not_to have_start_for_free_link
      end
    end
  end

  def render_trail(trail)
    render "trails/header", trail: trail, topic: build_stubbed(:topic)
  end

  def have_start_for_free_link_to(target)
    have_css "a[href='#{target}']", text: I18n.t("trails.start_for_free")
  end

  def have_start_for_free_link
    have_css "a", text: I18n.t("trails.start_for_free")
  end

  def build_trail(sample_video:)
    build_stubbed(:trail, topics: [build_stubbed(:topic)]).tap do |trail|
      allow(trail).to receive(:sample_video).and_return(sample_video.wrapped)
    end
  end
end
