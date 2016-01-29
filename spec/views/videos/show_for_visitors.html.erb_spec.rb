require "rails_helper"

describe "videos/show_for_visitors" do
  include Rails.application.routes.url_helpers

  it "embeds a preview when available" do
    video = build_stubbed(:video)
    wistia_id = stub_wistia_id_for(video)

    render_video_page_for_guest(video: video)

    expect(rendered).to have_wistia_preview(wistia_id)
  end

  it "shows a thumbnail when there is no preview" do
    video = build_stubbed(:video, preview_wistia_id: nil)
    wistia_id = stub_thumbnail_wistia_id_for(video)

    render_video_page_for_guest(video: video)

    expect(rendered).to have_wistia_thumbnail(wistia_id)
  end

  context "when the video is accessible_without_subscription" do
    it "displays an 'Auth to Access' CTA" do
      video = build_stubbed(:video, :free_sample)

      render_video_page_for_guest video: video

      expect(rendered).to have_auth_to_access_cta_for(video)
      expect(rendered).not_to have_subscribe_to_view_full_video_cta
    end
  end

  context "when the video is not accessible_without_subscription" do
    it "displays a 'subscriber to view all' CTA" do
      video = build_stubbed(:video, accessible_without_subscription: false)

      render_video_page_for_guest video: video

      expect(rendered).to have_subscribe_to_view_full_video_cta
      expect(rendered).not_to have_auth_to_access_cta_for(video)
    end
  end

  def have_auth_to_access_cta_for(video)
    have_link(
      I18n.t("videos.show.auth_to_access_button_text"),
      href: video_auth_to_access_path(video),
    )
  end

  def have_subscribe_to_view_full_video_cta
    have_link(
      I18n.t("videos.show.subscribe_to_view_full_video_button_text"),
      href: join_path
    )
  end

  def have_wistia_thumbnail(wistia_id)
    have_css("img.thumbnail[data-wistia-id='#{wistia_id}']")
  end

  def have_wistia_preview(wistia_id)
    have_css("p[data-wistia-id='#{wistia_id}']")
  end

  def render_video_page_for_guest(video:)
    plan = double("plan", price: 29)
    assign :plan, plan
    assign :video, video
    assign :watchable, video.watchable

    view_stubs(:signed_in?).and_return(false)
    view_stubs(:signed_out?).and_return(true)
    view_stubs(:current_user_has_active_subscription?).and_return(false)
    render template: "videos/show_for_visitors"
  end

  def stub_wistia_id_for(video)
    preview_video = Clip.new("123")
    allow(video).to receive(:preview).and_return(preview_video)
    preview_video.wistia_id
  end

  def stub_thumbnail_wistia_id_for(video)
    wistia_id = "123"
    clip = double("Clip", wistia_id: wistia_id)
    thumbnail = VideoThumbnail.new(clip)
    allow(video).to receive(:preview).and_return(thumbnail)
    wistia_id
  end
end
