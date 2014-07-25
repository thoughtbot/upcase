require "spec_helper"

describe "videos/show" do
  it "embeds a preview when available" do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: "123456"
    )

    wistia_id = "123"
    preview_video = Clip.new(wistia_id)
    video.stubs(:preview).returns(preview_video)
    stub_controller(video)

    render template: "videos/show"

    expect(rendered).
      to have_css("p.videowrapper[data-wistia-id='#{wistia_id}']")
  end

  it "shows a thumbnail when there is no preview" do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: nil
    )

    wistia_id = "123"
    clip = stub(wistia_id: wistia_id)
    thumbnail = VideoThumbnail.new(clip)
    video.stubs(:preview).returns(thumbnail)
    stub_controller(video)

    render template: "videos/show"

    expect(rendered).to have_css("img.thumbnail[data-wistia-id='#{wistia_id}']")
  end

  def stub_controller(video)
    plan = stub("plan", individual_price: 29)
    assign :plan, plan
    assign :video, video

    view_stubs(:signed_out?).returns(true)
    view_stubs(:signed_in?).returns(false)
    view_stubs(:current_user_has_active_subscription?).returns(false)
  end
end
