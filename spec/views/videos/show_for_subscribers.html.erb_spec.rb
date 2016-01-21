require "rails_helper"

describe "videos/show_for_subscribers" do
  context "when the video is part of a trail" do
    it "displays the progress bar" do
      video = create(:video, :with_trail)

      render_video video.reload

      expect(rendered).to have_progress_bar
    end
  end

  context "when the video is part of a show, not a trail" do
    it "does not display a trail progress bar" do
      video = create(:video, :published, watchable: create(:show))

      render_video video

      expect(rendered).not_to have_progress_bar
    end
  end

  context "when the user is a sampler" do
    context "and the video is accessible_without_subscription" do
      it "displays a Subscribe Now to view all CTA" do
        video = build_stubbed(:video, :free_sample)

        render_video video

        expect(rendered).to have_subscribe_button
        expect(rendered).to have_subscribe_to_view_all_cta
        expect(rendered).not_to have_subscribe_to_view_full_video_cta
      end
    end

    context "and the video is not accessible_without_subscription" do
      it "displays a Subscribe to view full video CTA" do
        video = build_stubbed(:video, accessible_without_subscription: false)

        render_video video, has_access: false

        expect(rendered).to have_subscribe_button
        expect(rendered).to have_subscribe_to_view_full_video_cta
        expect(rendered).not_to have_subscribe_to_view_all_cta
      end
    end
  end

  def have_subscribe_button
    have_link(
      I18n.t("videos.show.subscribe_to_view_all_button_text"),
      href: join_path
    )
  end

  def have_subscribe_to_view_all_cta
    have_content I18n.t("videos.show.subscribe_to_view_all_callout_text")
  end

  def have_subscribe_to_view_full_video_cta
    have_content I18n.t("videos.show.subscribe_to_view_full_video_callout_text")
  end

  def render_video(video, has_access: true)
    assign :video, video
    view_stubs(:current_user).and_return(build_stubbed(:user))
    view_stubs(:current_user_has_access_to?).and_return(true)
    render template: "videos/show_for_subscribers"
  end

  def have_progress_bar
    have_css(".trails-progress")
  end
end
